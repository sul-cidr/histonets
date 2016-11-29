# frozen_string_literal: true

##
# ActiveRecord model for the CollectionTemplate
class CollectionTemplate < ApplicationRecord
  belongs_to :collection
  belongs_to :image, optional: true
  has_many :image_templates

  cattr_accessor :form_steps do
    %w(
      select_collection
      select_image
      image_clean
    )
  end

  ##
  # TODO: Unimplemented form steps to add:
  # crop_image
  # create_image_templates
  # create_image_paths
  # view_image_graph

  attr_accessor :form_step

  # TODO: Add step by step validations here
  # Step by step validations
  # An example
  # validates :image_id, presence: true,
  #                      if: -> { required_for_step?(:select_image) }
end
