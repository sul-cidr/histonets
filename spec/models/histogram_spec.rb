# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Histogram, type: :model do
  describe '#extract_and_parse_histogram' do
    let(:histogramable) { create(:image, file_name: 'yolo.jpg') }
    subject(:generic_histogram) do
      create(
        :histogram,
        histogramable_id: histogramable.id,
        histogramable_type: 'Image'
      )
    end
    let(:extractor) { instance_double(HistogramExtractor) }
    it 'extracts and saves a histogram' do
      expect(HistogramExtractor).to receive(:new)
        .with('yolo.jpg').and_return(extractor)
      expect(extractor).to receive(:extract_and_parse_histogram).and_return({
        fake: :histogram
      }.to_json)
      generic_histogram.extract_and_parse_histogram
      expect(generic_histogram.histogram).to eq '{"fake":"histogram"}'
    end
  end
end
