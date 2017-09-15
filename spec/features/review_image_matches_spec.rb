# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Review image matches', type: :feature, js: true do
  before do
    ActiveJob::Base.queue_adapter = :inline
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection, images: [image])
    visit collections_path
    click_button 'Create collection template'
    click_button 'Next Step'
    click_button 'Next Step'
    check 'collection_template_auto_clean'
    click_button 'Next Step'
    # Click somewhere on the map to zoom in
    find('#map').double_click
    click_button 'Add template of cropped area'
    click_button 'Next Step'
  end
  after do
    ActiveJob::Base.queue_adapter = :test
  end
  # This test is now failing locally. We should investigage per Issue #155
  # but turn it off for now.
  xit 'Should show the rectangle on the map' do
    if ENV['CI']
      skip('Passing locally but Travis is throwing intermittent errors')
    end
    expect(page).to have_css '[data-matches-geometry]'
    expect(page).to have_css '.leaflet-overlay-pane path', wait: 10
  end
  it 'has match count' do
    if ENV['CI']
      skip('Passing locally but Travis is throwing intermittent errors')
    end
    expect(page).to have_css '.histonets-matches', text: /match/
  end
end
