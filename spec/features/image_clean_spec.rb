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
  describe 'image viewer' do
    it 'has tiled images' do
      expect(page).to have_css '[data-react-class="LeafletIiif"]'
      expect(page)
        .to have_css '.leaflet-tile-container img[src*="/image-service/eddie"]'
    end
  end
  describe 'image clean form' do
    it 'all sliders are disabled' do
      expect(page).to have_css 'input[type="range"][disabled]', count: 6
    end
    it 'enabling and moving range sends through option' do
      expect(page).to have_css 'input[type="range"]'
      expect(page).to have_css '[data-react-class="ToggleSlider"] div',
                               text: '100'
      find('[for="collection_template_image_clean_contrast_enabled"]').click
      # Check that default is there first
      expect(page).to have_xpath '//input[@id="'\
        'collection_template_image_clean_contrast"][@value=100]'
      ##
      # FIXME: We have an issue where a range set that isn't the max goes to the
      # max anyways. So setting the max here and leaving a comment for
      # transparency
      find(:xpath, '//input[@id="collection_template_image_clean_contrast"]')
        .set 200
      click_button 'Next Step'
      expect(CollectionTemplate.last.image_clean).to eq('contrast' => '200')
    end
  end
end
