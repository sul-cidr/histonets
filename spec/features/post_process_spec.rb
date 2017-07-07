# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post process image paths', type: :feature, js: true do
  before do
    ActiveJob::Base.queue_adapter = :inline
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection, images: [image])
    visit collections_path
    click_button 'Create collection template'
    click_button 'Next Step'
    click_button 'Next Step'
    click_button 'Next Step'
    check 'collection_template_auto_clean'
    click_button 'Next Step'
    # Click somewhere on the map to zoom in
    find('#map').double_click
    click_button 'Add template of cropped area'
    click_button 'Next Step'
    click_button 'Next Step'
    expect(page).to have_css '.histogram-color', count: 8
    first('.media-body').click
    click_button 'Next Step'
  end
  after do
    ActiveJob::Base.queue_adapter = :test
  end
  it 'Should display map of post processed' do
    expect(page).to have_css 'h1', text: 'Post Process Template Match Results'
    expect(page).to have_css '#map'
  end
end
