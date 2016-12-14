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
             image: create(:image, file_name: 'eddie.jpg'),
             auto_clean: true)
    end
    it 'calls the HistonetsCv::Cli enhance' do
      expect(cli_instance).to receive(:enhance)
        .with('9c7348b6ca1db7ca63aa49d9662a685f', '')
      subject.perform(collection_template)
    end
  end
end
