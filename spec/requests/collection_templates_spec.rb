# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection Template requests' do
  let(:collection_template) { create(:collection_template) }
  it do
    expect_any_instance_of(CollectionTemplate).to receive(:process_all_images)
    post "/collection_templates/#{collection_template.id}/process_images"
  end
end
