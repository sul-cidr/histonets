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
  it 'after creating image_templates sends to edit them' do
    click_button 'Add template of cropped area'
    click_button 'Add template of cropped area'
    click_button 'Next Step'
    2.times do
      expect(page).to have_css 'h1', text: 'Edit Image Templates'
      click_button 'Next Step'
    end
    expect(page).to have_css 'h1', text: 'Create Image Paths'
  end
end
