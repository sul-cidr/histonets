# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection', type: :feature, js: true do
  describe 'create collection templates from collection views' do
    before do
      ActiveJob::Base.queue_adapter = :inline
    end
    it 'creates a collection template for the correct collection' do
      visit new_collection_path
      fill_in 'Name', with: 'First Collection'
      fill_in 'Description', with: 'Collection Description'
      click_button 'Create collection'
      visit new_collection_path
      fill_in 'Name', with: 'Second Collection'
      fill_in 'Description', with: 'Collection Description'
      click_button 'Create collection'
      within page.all('.collection-item')[1] do
        click_button 'Create collection template'
      end
      col_select = 'collection_template[collection_id]'
      expect(page).to have_select(col_select, selected: 'Second Collection')
    end
  end
end
