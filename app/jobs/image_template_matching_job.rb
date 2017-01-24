# frozen_string_literal: true

##
# Job for image template matching
class ImageTemplateMatchingJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    collection_template.create_image_template_matches
  end
end
