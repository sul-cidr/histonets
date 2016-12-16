# frozen_string_literal: true

##
# Job for processing ImageClean step
class CalculateHistogramJob < ApplicationJob
  queue_as :default

  def perform(image)
    histogram = Histogram.find_or_create_by!(image: image)
    histogram.extract_and_parse_histogram
  end
end
