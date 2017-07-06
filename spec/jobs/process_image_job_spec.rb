# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessImageJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:images) { create_list(:image, 5) }
    let(:collection) { create(:collection, images: images) }
    let(:collection_template) do
      create(:collection_template, collection: collection,
                                   image: images.first, auto_clean: true)
    end
    context 'when autocleaning' do
      it 'calls the autoclean command "enhance"' do
        expect(cli_instance).to receive(:enhance)
          .with(
            '1_imageclean',
            'http://localhost:1337/image-service/'\
              "#{images.first.file_name_no_extension}/full/full/0/default.png"
          )
        ## Stub out other calls that are going to happen
        expect(cli_instance).to receive(:match).and_return '[]'
        expect(cli_instance).to receive(:select)
        described_class.new.perform(collection_template, images.first)
      end
    end
    context 'when manual cleaning' do
      it 'uses manual cleaning process via the pipeline' do
        collection_template.auto_clean = false
        collection_template.image_clean = { 'contrast' => '42' }
        expect(cli_instance).to receive(:pipeline)
          .with(
            '[{"action":"contrast","options":{"value":42}}]',
            'http://localhost:1337/image-service/'\
              "#{images.first.file_name_no_extension}/full/full/0/default.png",
            '1_imageclean'
          )
        ## Stub out other calls that are going to happen
        expect(cli_instance).to receive(:match).and_return '[]'
        expect(cli_instance).to receive(:select)
        described_class.new.perform(collection_template, images.first)
      end
    end
    it 'calls the creation of image templates' do
      expect(cli_instance).to receive(:match).with(
        '',
        'http://localhost:1337/image-service/'\
          "#{images.first.file_name_no_extension}_2_imageclean_tmp"\
          '/full/full/0/default.png'
      ).and_return '[]'
      ## Stub out other calls that are going to happen
      expect(cli_instance).to receive(:enhance)
      expect(cli_instance).to receive(:select)
      described_class.new.perform(collection_template, images.first)
    end
    it 'calls the creation of image paths' do
      expect(cli_instance).to receive(:select).with(
        '',
        '1_imagepaths',
        'http://localhost:1337/image-service/'\
          "#{images.first.file_name_no_extension}_2_imageclean_tmp"\
          '/full/full/0/default.png'
      ).and_return '[]'
      ## Stub out other calls that are going to happen
      expect(cli_instance).to receive(:enhance)
      expect(cli_instance).to receive(:match).and_return '[]'
      described_class.new.perform(collection_template, images.first)
    end
  end
  describe 'trackable callbacks' do
    let(:images) { create_list(:image, 5) }
    let(:collection) { create(:collection, images: images) }
    let(:collection_template) do
      create(:collection_template, collection: collection,
                                   image: images.first, auto_clean: true)
    end
    it 'check status enqueuing' do
      described_class.perform_later(collection_template, images.first)
      expect(ProcessImageJob).to have_been_enqueued
      expect(ProcessTracker.find_by(
        trackable_id: collection_template.id
      ).enqueued?).to be true
    end
    describe 'check status started' do
      it 'skipped because we cannot test the callback'
    end
    it 'status completed' do
      expect(cli_instance).to receive(:enhance)
      expect(cli_instance).to receive(:select).and_return '[]'
      expect(cli_instance).to receive(:match).and_return '[]'
      described_class.perform_now(collection_template, images.first)
      expect(ProcessTracker.find_by(
        trackable_id: collection_template.id
      ).completed?).to be true
    end
  end
end
