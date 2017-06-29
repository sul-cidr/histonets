# frozen_string_literal: true

##
# Job for processing an entire Collection
class ProcessCollectionTemplateJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    collection_template.collection.images.each do |image|
      ProcessImageJob.perform_later(collection_template, image)
    end
  end
end
