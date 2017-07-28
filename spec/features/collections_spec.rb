# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection', type: :feature, js: true do
  describe 'create collection templates from collection views' do
    before do
      ActiveJob::Base.queue_adapter = :inline
      image = create(:image, file_name: 'small_map.jpg')
      create(:collection, images: [image])
    end
    it 'creates a collection template for the correct collection' do
      visit new_collection_path
      fill_in 'Name', with: 'Second Collection'
      fill_in 'Description', with: 'Collection Description'
      click_button 'Create collection'
      within page.all('.collection-item')[0] do
        click_button 'Create collection template'
      end
      expect(page).to have_content 'Select an Image'
      expect(page).to have_css 'form.edit_collection_template'
      expect(page).to have_css 'select.image-select-form'
      expect(page).to have_css 'img', count: 1
    end
  end
end
