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
             image: create(:image, file_name: 'eddie.jpg'),
             image_paths: ['123,34,234', '432,244,0'])
    end
    it 'calls the HistonetsCv::Cli select' do
      expect(cli_instance).to receive(:select)
        .with(
          '[123,34,234] [432,244,0]',
          '495cfb3737dac34bd5a94c06edd1392c_7b22ea_1b0f400',
          'http://localhost:1337/image-service/eddie_495cfb3737dac34bd5a94c06edd1392c_tmp/full/full/0/default.png'
        )
      subject.perform(collection_template)
    end
  end
end
