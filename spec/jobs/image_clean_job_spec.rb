# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageCleanJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template_with_image,
             image_clean: { 'contrast' => '42' })
    end
    it 'calls the HistonetsCv::Cli contrast' do
      expect(cli_instance).to receive(:contrast).with('42')
      subject.perform(collection_template)
    end
  end
end
