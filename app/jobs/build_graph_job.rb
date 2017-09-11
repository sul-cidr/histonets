# frozen_string_literal: true

##
# Job for building the graph
class BuildGraphJob < ApplicationJob
  queue_as :default

  def perform(collection_template)
    HistonetsCv::Cli.new(collection_template.image.file_name)
                    .graph(
                      collection_template.graph_params,
                      collection_template.graph_name,
                      collection_template.graph['format'],
                      collection_template.postprocessed_image_url
                    )
  end
end
