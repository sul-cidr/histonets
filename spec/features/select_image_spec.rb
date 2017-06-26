# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Selecting an image for a template', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'eddie.jpg')
    create(:collection, images: [image])
  end
  it 'renders the select form' do
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
    expect(page).to have_content 'Select an Image'
    expect(page).to have_css 'form.edit_collection_template'
    expect(page).to have_css 'select.image-select-form'
  end
end
