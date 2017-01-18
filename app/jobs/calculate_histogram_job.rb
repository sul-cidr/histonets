# frozen_string_literal: true

##
# Job for processing ImageClean step
class CalculateHistogramJob < ApplicationJob
  queue_as :default

  def perform(histogramable)
    histogram = Histogram.find_or_create_by!(
      histogramable_id: histogramable.id,
      histogramable_type: histogramable.class.name
    )
    histogram.extract_and_parse_histogram
  end
end
