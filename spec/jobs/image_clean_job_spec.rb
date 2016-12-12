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
             image_clean: { 'contrast' => '42' },
             image: create(:image, file_name: 'eddie.jpg'),
             crop_bounds: [0, 0, 100, 100])
    end
    it 'calls the HistonetsCv::Cli contrast' do
      expect(cli_instance).to receive(:pipeline)
        .with(
          '[{"action":"contrast","options":{"value":42}}]',
          'http://localhost:3000/image-service/eddie/%5B0,%200,%20100,%20100%5D/full/0/default.jpg',
          '7cb8c070623c1db192209569a433ff00'
        )
      subject.perform(collection_template)
    end
  end
end
