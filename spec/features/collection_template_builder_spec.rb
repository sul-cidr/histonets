# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection Template Builder', type: :feature, js: true do
  describe 'step by step building' do
    before do
      image = create(:image, file_name: 'eddie.jpg')
      create(:collection, images: [image])
    end
    it 'renders and creates consecutive form steps' do
      visit new_collection_template_path
      click_link 'Build a Collection Template'
      click_button 'Next Step'
      click_button 'Next Step'
      expect(page).to have_css 'body', text: 'Crop Area of Interest'
      click_button 'Next Step'
      expect(page)
        .to have_css 'body', text: 'Automatic or Manual Image Cleaning'
      click_button 'Next Step'
      expect(page).to have_css 'body', text: 'Clean Image'
      click_button 'Next Step'
      click_button 'Next Step'
      click_button 'Next Step'
      click_button 'Next Step'
      # Just a basic show page with some json rendered
      expect(page).to have_css 'body', text: '{"id":'
    end
    context 'when using auto clean' do
      it 'skips manual clean' do
        visit new_collection_template_path
        click_link 'Build a Collection Template'
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
        visit new_collection_template_path
        click_link 'Build a Collection Template'
        click_button 'Next Step'
        click_button 'Next Step'
        click_button 'Next Step'
        click_button 'Next Step'
      end.to change { CollectionTemplate.count }.by(1)
    end
  end
end
