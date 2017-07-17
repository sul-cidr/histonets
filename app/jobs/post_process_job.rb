# frozen_string_literal: true.

##
# Encapsulates the skeletonize process for the job pipeline.
class PostProcessJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .skeletonize(
                      collection_template.formatted_skeletonize_params,
                      collection_template.postprocessed_image,
                      collection_template.pathselected_image_url
                    )
  end
end
