# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PathSelectJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             image_paths: ['123,34,234', '432,244,0'])
    end
    it 'calls the HistonetsCv::Cli select' do
      expect(cli_instance).to receive(:select)
        .with(
          '[123,34,234] [432,244,0]',
          '0be5efdb4c9b1d2b1ec690cf6b9bc396_7b22ea_1b0f400',
          'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396_tmp/full/full/0/default.png'
        )
      subject.perform(collection_template)
    end
  end
end
