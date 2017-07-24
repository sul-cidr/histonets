# frozen_string_literal: true

##
# Encapsulates the skeletonize process for the job pipeline.
class PostProcessJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .pipeline(
                      collection_template.postprocess_params_to_formal_json,
                      collection_template.pathselected_image_url,
                      collection_template.fingerprint_postprocessed
                    )
  end
end
