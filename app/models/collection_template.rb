# frozen_string_literal: true

##
# ActiveRecord model for the CollectionTemplate
# rubocop:disable Metrics/ClassLength
class CollectionTemplate < ApplicationRecord
  belongs_to :collection
  belongs_to :image, optional: true
  has_many :image_templates, dependent: :destroy
  has_one :histogram, dependent: :destroy, as: :histogramable
  has_many :process_trackers, dependent: :destroy, as: :trackable

  # Used by Histogram to figure out where the file is

  alias_attribute :file_name, :cleaned_file_name

  accepts_nested_attributes_for :image_templates,
                                reject_if: :reject_image_templates

  serialize :image_clean, Hash
  serialize :image_matches, Array
  serialize :image_paths, Array
  serialize :skeletonize, Hash
  serialize :ridges, Hash
  serialize :enabled_options, Hash
  serialize :graph, Hash
  serialize :blobs, Hash

  delegate :manifest, :annotations, to: :manifest_presenter
  delegate :palette, to: :collection

  cattr_accessor :form_steps do
    %w(
      select_image
      crop_image
      auto_clean
      image_clean
      create_image_templates
      review_template_match_results
      create_image_paths
      post_process_image_paths
      build_graph
    )
  end

  ##
  # TODO: Unimplemented form steps to add:
  # view_image_graph

  attr_accessor :form_step

  def parsed_histogram
    return JSON.parse(histogram.histogram) unless histogram.nil?
    []
  end

  def image_clean_to_formal_json
    json_params = HashWithIndifferentAccess.new(image_clean)
    pipeline_params = []
    json_params.each do |k, v|
      if k.to_s != 'posterize_method' && k.to_s != 'posterize'
        pipeline_params.push(action: k, options: { value: v.to_i })
      end
    end
    pipeline_params.to_json
  end

  def posterize_params
    json_params = HashWithIndifferentAccess.new(image_clean)
    "-p '#{palette}' -m #{json_params['posterize_method']} " \
      "#{json_params['posterize']}"
  end

  def palette_params
    json_params = HashWithIndifferentAccess.new(image_clean)
    if json_params.key?(:posterize)
      palette_params = "-c #{json_params['posterize']} " \
                       "-m #{json_params['posterize_method']}"
    else
      palette_params = ''
    end
    palette_params
  end

  def cleaned_image
    "#{image.file_name_no_extension}_"\
    "#{fingerprinted_name}_tmp"
  end

  def pathselected_image
    "#{image.file_name_no_extension}_"\
    "#{fingerprint_pathselection}_tmp"
  end

  def fingerprint_pathselection
    "#{fingerprinted_name}_"\
    "#{image_paths_to_hex.join('_')}"
  end

  def postprocessed_image
    "#{image.file_name_no_extension}_"\
    "#{fingerprint_postprocessed}_tmp"
  end

  def fingerprint_postprocessed
    "#{fingerprint_pathselection}_"\
    'postprocess'
  end

  def fingerprinted_partial_clean_name
    "#{fingerprinted_name}_"\
    'partial'
  end

  def partial_clean_image
    "#{image.file_name_no_extension}_"\
    "#{fingerprinted_partial_clean_name}_tmp"
  end

  def partial_clean_image_url
    return '' unless partial_clean_image.present?
    "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      partial_clean_image,
      region: 'full',
      size: 'full',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  def image_paths_to_hex
    image_paths.map do |image_path|
      # split on commas
      image_path.split(',')
                .map { |value| value.to_i.to_s(16).rjust(2, '0') }.join('')
      # convert string to int to hex string and justify
      # http://blog.lebrijo.com/converting-rgb-colors-to-hexadecimal-with-ruby/
    end
  end

  def cleaned_file_name
    "#{cleaned_image}.#{Settings.DEFAULT_IMAGE_EXTENSION}"
  end

  def cleaned_image_url
    return '' unless cleaned_image.present?
    "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      cleaned_image,
      region: 'full',
      size: 'full',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  def pathselected_image_url
    return '' unless pathselected_image.present?
    "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      pathselected_image,
      region: 'full',
      size: 'full',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  def postprocessed_image_url
    return '' unless postprocessed_image.present?
    "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      postprocessed_image,
      region: 'full',
      size: 'full',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  def fingerprinted_name
    Digest::MD5.hexdigest(
      [
        image.file_name,
        auto_clean,
        image_clean_to_formal_json,
        cropped_image
      ].join(' ')
    )
  end

  def cropped_image
    return '' unless crop_bounds.present?
    "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      image.file_name_no_extension,
      region: crop_bounds,
      size: 'full',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  def calculate_histogram
    CalculateHistogramJob.perform_later(self)
  end

  def create_image_template_matches
    temp = HistonetsCv::Cli.new(image.file_name)
                           .match(
                             image_templates.map(&:cli_options).join(' '),
                             cleaned_image_url
                           )
    self.image_matches = JSON.parse(temp)
    save
  end

  ##
  # A nice formatting that the CLI will like
  def formatted_image_paths
    image_paths.map { |image_path| "[#{image_path}]" }.join(' ')
  end

  def enhance_params
    collection = Collection.find(collection_id)
    "-p '#{collection.palette}'"
  end

  def ridges_params
    ridge_cli_params = {}
    ridges_params = HashWithIndifferentAccess.new(ridges)
    ridges_params.each do |k, v|
      ridge_cli_params.merge!(k => v.to_i)
    end
    ridge_cli_params
  end

  def blobs_params
    blobs_cli_params = {}
    blobs_params = HashWithIndifferentAccess.new(blobs)
    blobs_params.each do |k, v|
      blobs_cli_params.merge!(k => v.to_i)
    end
    blobs_cli_params
  end

  def skeletonize_params
    skeletonize_cli_params = {}
    skeletonize_params = HashWithIndifferentAccess.new(skeletonize)
    skeletonize_params.each do |k, v|
      if k.to_s == 'dilation'
        skeletonize_cli_params.merge!(k => v.to_i)
      else
        skeletonize_cli_params.merge!(k => v)
      end
    end
    skeletonize_cli_params
  end

  def postprocess_params_to_formal_json
    pipeline_params = []
    if enabled_options['ridges'] == 'true'
      pipeline_params.push(action: 'ridges', options: ridges_params)
    end
    if enabled_options['blobs'] == 'true'
      pipeline_params.push(action: 'blobs', options: blobs_params)
    end
    pipeline_params.push(action: 'skeletonize', options: skeletonize_params)
    pipeline_params.to_json
  end

  def graph_params
    "'#{image_matches}' -sm #{graph['simplification-method']}" \
      " -st #{graph['simplification-tolerance']} -f #{graph['format']}"
  end

  # It might be better to do something with the collection id
  # and the template id here, but it would need to use some
  # fingerprint to dist btw multiple templates for same coll
  def graph_name
    "#{fingerprint_postprocessed}_"\
    'graph'
  end

  def manifest_presenter
    ManifestPresenter.new(self)
  end

  def process_all_images
    collection.images.map do |image|
      ProcessImageJob.perform_later(self, image)
    end
  end

  private

  def reject_image_templates(attributes)
    attributes['image_url'].blank?
  end

  # TODO: Add step by step validations here
  # Step by step validations
  # An example
  # validates :image_id, presence: true,
  #                      if: -> { required_for_step?(:select_image) }
end
# rubocop:enable Metrics/ClassLength
