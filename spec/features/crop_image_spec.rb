# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crop image', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
    click_button 'Next Step'
  end
  it 'has image viewer with crop and saves crop' do
    expect(page).to have_css 'div#iiif-cropper'
    expect(page).to have_css '.leaflet-areaselect-container'
    expect(page)
      .to have_css '.leaflet-tile-container '\
                   'img[src*="/image-service/small_map"]'
    click_button 'Next Step'
    expect(CollectionTemplate.last.crop_bounds).to eq('0,0,300,300')
  end
end
