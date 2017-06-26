# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Image path editing', type: :feature, js: true do
  before do
    ActiveJob::Base.queue_adapter = :inline
    image = create(:image, file_name: 'eddie.jpg')
    create(:collection, images: [image])
    visit new_collection_template_path
    click_link 'Build a Collection Template'
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
  end
  after do
    ActiveJob::Base.queue_adapter = :test
  end
  it 'Should display the precalculated histograms with persisted image paths' do
    expect(page).to have_css '.histogram-color', count: 8
    first('.media-body').click
    click_button 'Next Step'
    expect(CollectionTemplate.last.image_paths.count).to eq 1
  end
end
