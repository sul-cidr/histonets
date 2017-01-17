# frozen_string_literal: true

##
# ActiveRecord model for storing Image's histograms. Just loading these objects
# is expensive.
class Histogram < ApplicationRecord
  include ActiveSupport::Benchmarkable

  belongs_to :histogramable, polymorphic: true
  delegate :file_name, to: :histogramable

  ##
  # Extracts, parses, and saves the histogram
  def extract_and_parse_histogram
    self.histogram = HistogramExtractor.new(file_name)
                                       .extract_and_parse_histogram
    save
  end
end
