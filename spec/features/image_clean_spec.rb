# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Image clean', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
    click_button 'Next Step'
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
        expect(page).to have_css 'input[type="range"]'
        expect(page).to have_css 'div#image-clean-contrast div',
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
        expect(CollectionTemplate.last.image_clean).to eq('contrast' => '200')
      end
      it 'enabling posterize method buttons passes through option' do
        find('[for="collection_template_image_clean_posterize_enabled"]').click
        expect(page).to have_xpath '//input[@name="'\
          'collection_template[image_clean][posterize_method]"]'
        click_button 'Next Step'
        expect(CollectionTemplate.last.image_clean)
          .to eq('posterize' => '0', 'posterize_method' => 'kmeans')
      end
      it 'enqueues the histogram calculation' do
        ActiveJob::Base.queue_adapter = :test
        find('[for="collection_template_image_clean_posterize_enabled"]').click
        expect(page).to have_xpath '//input[@name="'\
          'collection_template[image_clean][posterize_method]"]'
        expect do
          click_button 'Next Step'
        end.to have_enqueued_job(CalculateHistogramJob)
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
    it 'enqueues the histogram calculation' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        click_button 'Next Step'
      end.to have_enqueued_job(CalculateHistogramJob)
    end
  end
end
