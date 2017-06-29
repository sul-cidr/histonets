# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessCollectionTemplateJob, type: :job do
  describe '#perform' do
    let(:images) { create_list(:image, 5) }
    let(:collection) { create(:collection, images: images) }
    let(:collection_template) do
      create(:collection_template, collection: collection, image: images.first)
    end
    it 'fires off ProcessImageJob for each image in the collection' do
      expect(ProcessImageJob).to receive(:perform_later).exactly(5).times
      described_class.new.perform(collection_template)
    end
  end
end
