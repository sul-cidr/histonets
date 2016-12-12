# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crop image', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'eddie.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
    click_button 'Next Step'
  end
  it 'has image viewer (no way to check for canvas image) and saves crop' do
    expect(page).to have_css '.openseadragon-canvas'
    click_button 'Next Step'
    expect(CollectionTemplate.last.crop_bounds).to eq('-2093,355,1613,806')
  end
end
