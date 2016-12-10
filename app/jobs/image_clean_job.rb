# frozen_string_literal: true

##
# Job for processing ImageClean step
class ImageCleanJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .pipeline(collection_template.image_clean_to_formal_json)
  end
end
