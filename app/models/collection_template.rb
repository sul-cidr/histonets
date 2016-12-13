# frozen_string_literal: true

##
# ActiveRecord model for the CollectionTemplate
class CollectionTemplate < ApplicationRecord
  belongs_to :collection
  belongs_to :image, optional: true
  has_many :image_templates

  serialize :image_clean, Hash

  cattr_accessor :form_steps do
    %w(
      select_collection
      select_image
      crop_image
      image_clean
      create_image_templates
    )
  end

  ##
  # TODO: Unimplemented form steps to add:
  # create_image_paths
  # view_image_graph

  attr_accessor :form_step

  def image_clean_to_formal_json
    pipeline_params = []
    image_clean.each do |k, v|
      if k.to_s == 'posterize'
        pipeline_params.push(action: k, options:
          { colors: v.to_i, method: 'kmeans' })
      else
        pipeline_params.push(action: k, options: { value: v.to_i })
      end
    end
    pipeline_params.to_json
  end

  def cleaned_image
    "#{image.file_name_no_extension}_"\
    "#{Digest::MD5.hexdigest(image_clean_to_formal_json)}_tmp"
  end

  # TODO: Add step by step validations here
  # Step by step validations
  # An example
  # validates :image_id, presence: true,
  #                      if: -> { required_for_step?(:select_image) }
end
