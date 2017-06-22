# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateHistogramJob, type: :job do
  let(:riiif_instance) { instance_double(Riiif::File) }
  before do
    expect(Riiif::File).to receive(:new)
      .with('spec/fixtures/images/yolo.jpg').and_return(riiif_instance)
    expect(riiif_instance).to receive(:extract).with(
      Riiif::Transformation.new(
        nil, nil, nil, nil,
        '-define histogram:unique-colors=true -format %c histogram:info'
      )
    ).and_return(
      "     18: (162,129, 50) #A28132 srgb(162,129,50)\n"\
      "     14: (162,142,107) #A28E6B srgb(162,142,107)\n"\
      "     1: (162,142,141) #A28E8D srgb(162,142,141)\n"
    )
  end
  describe '#perform' do
    subject(:image) { create(:image, file_name: 'yolo.jpg') }
    it 'extracts, parses, and saves the histogram' do
      described_class.new.perform(image)
      expect(JSON.parse(image.histogram.histogram)).to include(
        '(162,129,50)' => '18',
        '(162,142,107)' => '14',
        '(162,142,141)' => '1'
      )
    end
  end
end
