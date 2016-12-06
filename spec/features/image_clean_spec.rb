# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Image clean', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'eddie.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
    click_button 'Next Step'
    click_button 'Next Step'
  end
  it 'has image viewer with tiled images' do
    expect(page).to have_css '[data-react-class="LeafletIiif"]'
    expect(page)
      .to have_css '.leaflet-tile-container img[src*="/image-service/eddie"]'
  end
end
