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
  it 'after creating image_templates, creates an edit page for each' do
    click_button 'Add template of cropped area'
    click_button 'Add template of cropped area'
    click_button 'Next Step'
    2.times do
      expect(page).to have_css 'h1', text: 'Edit Image Templates'
      click_button 'Next Step'
    end
    expect(page).to have_css 'h1', text: 'Create Image Paths'
  end
  describe 'edit image form' do
    before do
      click_button 'Add template of cropped area'
      click_button 'Next Step'
    end
    it 'all inputs are disabled' do
      expect(page).to have_css 'input[type="range"][disabled]', count: 3
    end
    it 'input defaults are correct' do
      expect(page).to have_xpath '//input[@id="'\
        'image_template_match_options_threshold"][@value=80]'
      expect(page).to have_xpath '//input[@id="'\
        'image_template_match_options_elasticity"][@value=0]'
      expect(page).to have_xpath '//input[@id="'\
        'image_template_match_options_rotation"][@value=0]'
    end
    it 'enabling threshold sends through option' do
      find('[for="image_template_match_options_threshold_enabled"]').click
      click_button 'Next Step'
      expect(ImageTemplate.last.match_options).to eq('threshold' => '80')
    end
  end
end
