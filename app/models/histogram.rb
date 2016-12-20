# frozen_string_literal: true

##
# ActiveRecord model for storing Image's histograms. Just loading these objects
# is expensive.
class Histogram < ApplicationRecord
  include ActiveSupport::Benchmarkable

  belongs_to :image
  delegate :file_name, to: :image

  ##
  # Extracts, parses, and saves the histogram
  def extract_and_parse_histogram
    raw_output = nil
    logger.info("Extracting histogram from #{file_name}")
    benchmark("Extracted histogram from #{file_name}") do
      raw_output = extract_histogram
    end
    logger.info("Parsing and saving histogram #{file_name}")
    benchmark('Parsed and saved histogram') do
      # Store the Histogram as JSON (but saving as binary for performance)
      self.histogram = Histogram.parse_histogram(raw_output).to_json
      save
    end
  end

  ##
  # For a given image, extract the histogram from ImageMagick
  def extract_histogram
    Riiif::File.new("#{Settings.IMAGE_PATH}/#{file_name}")
               .extract(
                 format: '-define histogram:unique-colors=true -format %c'\
                   ' histogram:info'
               )
  end

  ##
  # Parses raw output from ImageMagick histogram into a Hash
  def self.parse_histogram(raw_output)
    raw_output.each_line.map do |line|
      [
        /\([0-9]*,[0-9]*,[0-9]*\)/.match(line.delete(' '))[0],
        /[0-9]*:/.match(line)[0].sub(':', '')
      ]
    end.to_h
  end
end