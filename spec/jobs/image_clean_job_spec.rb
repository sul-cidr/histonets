# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageCleanJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             image_clean: { 'contrast' => '42' },
             crop_bounds: '0,0,100,100')
    end
    it 'calls the HistonetsCv::Cli contrast' do
      expect(cli_instance).to receive(:pipeline)
        .with(
          '[{"action":"contrast","options":{"value":42}}]',
          'http://localhost:1337/image-service/small_map/0,0,100,100/full/0/default.png',
          '338221af315f9de7056ef3d9b751200f_partial'
        )
      subject.perform(collection_template)
    end
  end
end
