# frozen_string_literal: true

##
# Job for auto-magical image enhancement
class ImageEnhanceJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .enhance(
                      collection_template.fingerprinted_name,
                      collection_template.cropped_image
                    )
  end
end
