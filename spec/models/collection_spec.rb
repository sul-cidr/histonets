# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  it 'does not have to have images' do
    expect(create(:collection)).to be_an described_class
  end
  it 'can have many images' do
    expect(create(:collection_with_images).images.length).to eq 5
  end
  describe 'with collection templates' do
    let(:collection) { create(:collection) }
    let(:collection_template) { create(:collection_template) }
    it 'has dependent collection templates' do
      collection.collection_templates << collection_template
      expect { collection.destroy }.to change(CollectionTemplate, :count)
    end
  end
  describe '#create_composite_histogram' do
    let(:histogram_extractor) { instance_double(HistogramExtractor) }
    before do
      allow(HistogramExtractor).to receive(:new).and_return(histogram_extractor)
    end
    subject { create(:collection_with_images) }
    it 'creates histograms for all of the images if not present' do
      subject.images.first.histogram = create(
        :histogram,
        histogram: {
          '(255,255,255)' => 1,
          '(0,0,0)' => 2
        }.to_json,
        histogramable_id: subject.images.first.id,
        histogramable_type: 'Image'
      )
      expect(histogram_extractor).to receive(:extract_and_parse_histogram)
        .and_return(
          {
            '(255,255,255)' => 1,
            '(0,0,0)' => 2
          }.to_json
        ).exactly(4).times
      subject.create_composite_histogram
    end
    it 'creates a composite that sums all of the counts' do
      expect(histogram_extractor).to receive(:extract_and_parse_histogram)
        .and_return(
          {
            '(255,255,255)' => '1',
            '(0,0,0)' => '2'
          }.to_json
        ).exactly(5).times
      subject.create_composite_histogram
      expect(subject.histogram.parsed_histogram)
        .to include('(255,255,255)' => 5)
      expect(subject.histogram.parsed_histogram).to include('(0,0,0)' => 10)
    end
  end
end
