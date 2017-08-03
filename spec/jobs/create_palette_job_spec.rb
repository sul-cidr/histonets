# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePaletteJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:image) { create(:image, file_name: 'small_map.jpg') }
    let(:collection) { create(:collection, images: [image]) }
    it 'calls the HistonetsCv::Cli palette' do
      collection.create_composite_histogram
      expect(cli_instance).to receive(:palette)
        .with('spec/fixtures/data/collection_1_histogram.txt')
        .and_return('a palette')
      subject.perform(collection)
    end
  end
end
