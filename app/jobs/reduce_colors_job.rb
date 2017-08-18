# frozen_string_literal: true

##
# Job for reducing colors in an image
class ReduceColorsJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .posterize(
                      collection_template.posterize_params,
                      collection_template.fingerprinted_reduced_name,
                      collection_template.cleaned_image_url
                    )
  end
end
