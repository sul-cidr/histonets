# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageEnhanceJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             auto_clean: true)
    end
    it 'calls the HistonetsCv::Cli enhance' do
      expect(cli_instance).to receive(:enhance)
        .with('9d7fc6f4f87c77c73c959ab3d9e0f2d8', '')
      subject.perform(collection_template)
    end
  end
end
