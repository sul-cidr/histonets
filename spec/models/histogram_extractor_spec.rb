# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistogramExtractor, type: :model do
  describe '#extract_histogram' do
    subject(:generic_histogram) do
      described_class.new('yolo.jpg')
    end
    let(:riiif_instance) { instance_double(Riiif::File) }
    it 'receives file_name from relation and calls extract' do
      expect(Riiif::File).to receive(:new)
        .with('spec/fixtures/images/yolo.jpg').and_return(riiif_instance)
      expect(riiif_instance).to receive(:extract).with(
        Riiif::Transformation.new(
          nil, nil, nil, nil,
          '-define histogram:unique-colors=true -format %c histogram:info'
        )
      )
      generic_histogram.extract_histogram
    end
  end
  describe '.parse_histogram' do
    let(:raw_input) do
      "     18: (162,129, 50) #A28132 srgb(162,129,50)\n"\
      "     14: (162,142,107) #A28E6B srgb(162,142,107)\n"\
      "                                                \n"\
      "     1: (162,142,141) #A28E8D srgb(162,142,141)\n"
    end
    subject(:parsed_response) { described_class.parse_histogram(raw_input) }
    it 'returns a hash from a raw string' do
      expect(parsed_response).to be_an Hash
    end
    it 'each line is a key,value pair' do
      expect(parsed_response.count).to eq 3
    end
    it 'keys are the rgb colors without whitespace' do
      expect(parsed_response.keys).to include('(162,129,50)')
    end
    it 'values are the counts' do
      expect(parsed_response.values).to include('18')
    end
  end
end
