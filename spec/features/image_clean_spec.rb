# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Image clean', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'small_map.jpg')
    collection = create(:collection, images: [image])
    collection.palette = '[[255, 255, 255], [220, 196, 142]]'
    visit collections_path
    click_button 'Create collection template'
    click_button 'Next Step'
    click_button 'Next Step'
  end
  context 'manual cleaning' do
    before do
      click_button 'Next Step'
    end
    describe 'image clean form' do
      it 'all inputs are disabled' do
        expect(page).to have_css 'input[type="range"][disabled]', count: 6
        expect(page).to have_css 'div.btn-group label', 'disabled'
      end
      it 'enabling and moving range sends through option' do
        find('[for="collection_template_image_clean_posterize_enabled"]').click
        evaluate_script(
          "document.getElementById('collection_template_image_clean"\
          "_posterize').value = '2'"
        )
        expect(page).to have_css 'input[type="range"]'
        expect(page).to have_css '[data-react-class="ToggleForm"] div',
                                 text: '100'
        find('[for="collection_template_image_clean_contrast_enabled"]').click
        # Check that default is there first
        expect(page).to have_xpath '//input[@id="'\
          'collection_template_image_clean_contrast"][@value=100]'
        ##
        # FIXME: We have an issue where a range set that isn't the max goes to
        # the max anyways. So setting the max here and leaving a comment for
        # transparency
        find(:xpath, '//input[@id="collection_template_image_clean_contrast"]')
          .set 200
        click_button 'Next Step'
        expect(CollectionTemplate.last.image_clean)
          .to eq('contrast' => '200', 'posterize' => '2',
                 'posterize_method' => 'kmeans')
      end
      it 'enabling posterize method buttons passes through option' do
        find('[for="collection_template_image_clean_posterize_enabled"]').click
        expect(page).to have_xpath '//input[@name="'\
          'collection_template[image_clean][posterize_method]"]'
        evaluate_script(
          "document.getElementById('collection_template_image"\
          "_clean_posterize').value = '2'"
        )
        find(:xpath, '//input[@id="collection_template_image_clean_posterize"]')
        click_button 'Next Step'
        expect(CollectionTemplate.last.image_clean)
          .to eq('posterize' => '2', 'posterize_method' => 'kmeans')
      end
    end
  end
  context 'auto cleaning' do
    before do
      check 'collection_template_auto_clean'
    end
    it 'saves and sets auto_clean' do
      click_button 'Next Step'
      expect(CollectionTemplate.last.auto_clean).to be true
    end
  end
end
