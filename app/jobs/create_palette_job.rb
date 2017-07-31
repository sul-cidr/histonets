# frozen_string_literal: true

##
# Job for creating collection palette
class CreatePaletteJob < ApplicationJob
  queue_as :default

  def perform(collection)
    temp = HistonetsCv::Cli.new
                           .palette(
                             collection.histogram_file_name
                           )
    collection.palette = temp.strip
    collection.save
  end
end
