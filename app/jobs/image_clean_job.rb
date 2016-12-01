# frozen_string_literal: true

##
# Job for processing ImageClean step
class ImageCleanJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    # TODO: The ImageClean object will provide a better serialization here. This
    # is a stopgap
    contrast = collection_template.image_clean['contrast']
    HistonetsCv::Cli.new(collection_template.image.file_name).contrast(contrast)
  end
end
