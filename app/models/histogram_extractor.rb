# frozen_string_literal: true

##
# Class for extracting histograms
class HistogramExtractor
  include ActiveSupport::Benchmarkable

  delegate :logger, to: :Rails

  attr_reader :file_name

  def initialize(file_name)
    @file_name = file_name
  end

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
      HistogramExtractor.parse_histogram(raw_output).to_json
    end
  end

  ##
  # For a given image, extract the histogram from ImageMagick
  def extract_histogram
    Riiif::File.new("#{Settings.IMAGE_PATH}/#{file_name}")
               .extract(
                 Riiif::Transformation.new(
                   nil, nil, nil, nil,
                   # Only provide :format for this Struct
                   '-define histogram:unique-colors=true -format %c'\
                     ' histogram:info'
                 )
               )
  end

  ##
  # Parses raw output from ImageMagick histogram into a Hash
  def self.parse_histogram(raw_output)
    output = raw_output.each_line.map do |line|
      [
        /\([0-9]*,[0-9]*,[0-9]*\)/.match(line.delete(' ')).to_s,
        /[0-9]*:/.match(line).to_s.sub(':', '')
      ]
    end.to_h
    output.delete_if { |k, v| v.empty? || k.empty? }
  end
end
