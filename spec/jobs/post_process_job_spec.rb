# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostProcessJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             skeletonize: {
               'method' => 'combined',
               'dilation' => 13,
               'binarization-method' => 'li'
             },
             ridges: {
               'width' => 6,
               'threshold' => 128,
               'dilation' => 3
             },
             enabled_options: {
               'ridges' => 'true'
             })
    end
    it 'calls the HistonetsCv::Cli skeletonize' do
      expect(cli_instance).to receive(:pipeline)
        .with(
          '[{"action":"ridges","options":{"width":6,"threshold":128,'\
          '"dilation":3}},{"action":"skeletonize","options":{"method":'\
          '"combined","dilation":13,"binarization-method":"li"}}]',
          'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396__tmp/full/full/0/default.png',
          '0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess'
        )
      subject.perform(collection_template)
    end
  end
end
