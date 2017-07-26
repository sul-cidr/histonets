# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection Template Builder', type: :feature, js: true do
  describe 'step by step building' do
    before do
      ActiveJob::Base.queue_adapter = :inline
      image = create(:image, file_name: 'small_map.jpg')
      create(:collection, images: [image])
    end
    it 'renders and creates consecutive form steps' do
      visit collections_path
      click_button 'Create collection template'
      click_button 'Next Step'
      click_button 'Next Step'
      expect(page).to have_css 'body', text: 'Crop Area of Interest'
      click_button 'Next Step'
      expect(page)
        .to have_css 'body', text: 'Automatic or Manual Image Cleaning'
      click_button 'Next Step'
      expect(page).to have_css 'body', text: 'Clean Image'
      ## We need to posterize this image
      find('[for="collection_template_image_clean_posterize_enabled"]').click
      evaluate_script(
        "document.getElementById('collection_template_image_clean_posterize')"\
          ".value = '4'"
      )
      click_button 'Next Step'
      # Click somewhere on the map to zoom in
      find('#map').double_click
      click_button 'Add template of cropped area'
      click_button 'Next Step'
      click_button 'Next Step'
      # Need to set a color for image paths
      expect(page).to have_css '.histogram-color', count: 4
      first('.form-check-input').click
      click_button 'Next Step'
      click_button 'Next Step'
      click_button 'Next Step'
      # Just a basic show page with some json rendered
      expect(page).to have_css 'body', text: '{"id":'
    end
    after do
      ActiveJob::Base.queue_adapter = :test
    end
    context 'when using auto clean' do
      it 'skips manual clean' do
        visit collections_path
        click_button 'Create collection template'
        click_button 'Next Step'
        click_button 'Next Step'
        click_button 'Next Step'
        check 'collection_template_auto_clean'
        click_button 'Next Step'
        expect(page).to have_css 'body', text: 'Create Image Templates'
      end
    end
    it 'increments CollectionTemplate' do
      expect do
        visit collections_path
        click_button 'Create collection template'
        click_button 'Next Step'
        click_button 'Next Step'
        click_button 'Next Step'
        click_button 'Next Step'
      end.to change { CollectionTemplate.count }.by(1)
    end
  end
end
