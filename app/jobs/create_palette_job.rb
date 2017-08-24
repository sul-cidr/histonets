# frozen_string_literal: true

##
# Job for creating collection palette
class CreatePaletteJob < ApplicationJob
  queue_as :default

  def perform(palette_params, collection)
    collection.save_avg_histogram_file
    temp = HistonetsCv::Cli.new
                           .palette(
                             palette_params,
                             collection.avg_histogram_file_name
                           )
    collection.palette = temp.strip
    collection.save
  end
end
