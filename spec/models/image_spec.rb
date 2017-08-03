# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'does not have to belong to a collection' do
    expect(create(:image)).to be_an described_class
  end
  it 'can belong to many collections' do
    expect(create(:image_with_collections).collections.length).to eq 3
  end
  describe '.from_file_path' do
    it 'creates an Image' do
      expect(described_class.from_file_path('/dev/null/awesome.jpg'))
        .to be_an described_class
    end
    it 'creates an Image with file_name correctly' do
      expect(described_class.from_file_path('/dev/null/awesome.jpg').file_name)
        .to eq 'awesome.jpg'
    end
  end
  describe '#file_name_no_extension' do
    it 'returns the filename without an extension' do
      expect(create(:image).file_name_no_extension).to match(/eddie[0-9]*/)
    end
  end
  describe '#extension' do
    it 'returns the filename extension' do
      expect(create(:image).extension).to eq '.jpg'
    end
  end
  describe '#thumbnail_image_path' do
    it 'returns a IIIF url' do
      expect(create(:image).thumbnail_image_path)
        .to match(/.*localhost.*image-service.*200,/)
    end
  end
  describe '#full_image_path' do
    it 'returns a IIIF url' do
      expect(create(:image).full_image_path)
        .to match(%r{.*localhost.*image-service.*full\/full})
    end
  end
  describe '#calculate_histogram' do
    let(:image) { create(:image) }
    it 'queues the calculate histogram job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        image.send(:calculate_histogram)
      end.to have_enqueued_job(CalculateHistogramJob)
    end
  end
end
