# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Review image matches', type: :feature, js: true do
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
  it 'Should show the rectangle on the map' do
    if ENV['CI']
      skip('Passing locally but Travis is throwing intermittent errors')
    end
    expect(page).to have_css '[data-matches-geometry]'
    expect(page).to have_css '.leaflet-overlay-pane path', wait: 10
  end
  it 'has match count' do
    expect(page).to have_css '.histonets-matches', text: '1 match'
  end
end
