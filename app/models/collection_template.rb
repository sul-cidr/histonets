# frozen_string_literal: true

##
# ActiveRecord model for the CollectionTemplate
class CollectionTemplate < ApplicationRecord
  belongs_to :collection
  belongs_to :image, optional: true
  has_many :image_templates, dependent: :destroy
  has_one :histogram, dependent: :destroy, as: :histogramable

  # Used by Histogram to figure out where the file is
  alias_attribute :file_name, :cleaned_file_name

  accepts_nested_attributes_for :image_templates,
                                reject_if: :reject_image_templates

  serialize :image_clean, Hash

  cattr_accessor :form_steps do
    %w(
      select_collection
      select_image
      crop_image
      auto_clean
      image_clean
      create_image_templates
      edit_image_templates
      create_image_paths
    )
  end

  ##
  # TODO: Unimplemented form steps to add:
  # create_image_paths
  # view_image_graph

  attr_accessor :form_step

  def image_clean_to_formal_json
    json_params = HashWithIndifferentAccess
                  .new_from_hash_copying_default(image_clean)
    pipeline_params = []
    json_params.each do |k, v|
      if k.to_s == 'posterize'
        pipeline_params.push(action: k, options:
          { colors: v.to_i, method: json_params[:posterize_method] })
      elsif k.to_s != 'posterize_method'
        pipeline_params.push(action: k, options: { value: v.to_i })
      end
    end
    pipeline_params.to_json
  end

  def cleaned_image
    "#{image.file_name_no_extension}_"\
    "#{fingerprinted_name}_tmp"
  end

  def cleaned_file_name
    "#{cleaned_image}.#{Settings.DEFAULT_IMAGE_EXTENSION}"
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

  ##
  # Query for unverified image_templates
  def unverified_image_templates
    image_templates.where(status: [false, nil])
  end

  ##
  # Set all `image_templates` as unverified|false
  def unverify_image_templates
    image_templates.map { |it| it.update(status: false) }
  end

  def calculate_histogram
    CalculateHistogramJob.perform_later(self)
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
