# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection Template Builder', type: :feature, js: true do
  describe 'step by step building' do
    before do
      ActiveJob::Base.queue_adapter = :inline
      image = create(:image, file_name: 'small_map.jpg')
      create(:collection, images: [image])
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
      end.to change { CollectionTemplate.count }.by(1)
    end
  end
end
