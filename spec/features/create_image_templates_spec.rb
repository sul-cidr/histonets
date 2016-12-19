# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create image templates', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'eddie.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
    click_button 'Next Step'
    click_button 'Next Step'
    check 'collection_template_auto_clean'
    click_button 'Next Step'
  end
  it 'has image templates listed and are persisted' do
    expect(page).to have_css '.image-template-list'
    click_button 'Add template of cropped area'
    expect(page).to have_css 'li img[src*="0,0,300,300"]'
    expect(page).to have_css 'img'
    click_button 'Next Step'
    expect(ImageTemplate.last.image_url).to match(/0,0,300,300/)
  end
end
