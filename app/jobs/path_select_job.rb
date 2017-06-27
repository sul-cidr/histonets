# frozen_string_literal: true

##
# Job for processing PathSelect step
class PathSelectJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .select(
                      collection_template.formatted_image_paths,
                      collection_template.fingerprint_pathselection,
                      collection_template.cleaned_image_url
                    )
  end
end
