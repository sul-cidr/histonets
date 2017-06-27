# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Selecting an image for a template', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'small_map.jpg')
    image2 = create(:image, file_name: '4799757.jpg')
    create(:collection, images: [image, image2])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
  end
  it 'renders the select form' do
    expect(page).to have_content 'Select an Image'
    expect(page).to have_css 'form.edit_collection_template'
    expect(page).to have_css 'select.image-select-form'
  end
  it 'creates image tags for the images in the collection' do
    expect(page).to have_css 'img.image_picker_image', count: 2
  end
  it 'highlights the correct image when you choose it in the select box' do
    find('select.image-select-form').find("option[value='2']").select_option
    expect(page).to have_css 'div.selected img[src*="4799757"]'
  end
end
