# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection Template requests' do
  describe 'POST process_images' do
    let(:collection_template) { create(:collection_template) }
    it do
      expect_any_instance_of(CollectionTemplate).to receive(:process_all_images)
      post "/collection_templates/#{collection_template.id}/process_images"
    end
  end

  describe 'GET download' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             graph: { 'format' => 'graphml' })
    end
    it 'send the graph file' do
      get "/collection_templates/#{collection_template.id}/download"
      expect(response.content_type).to eq('application/octet-stream')
      expect(response.status).to eq(200)
    end
  end
end
