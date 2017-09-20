# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Build graph', type: :feature, js: true do
  before do
    ActiveJob::Base.queue_adapter = :inline
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection,
           images: [image],
           palette: [[0, 0, 0], [255, 255, 255]])
    visit collections_path
    click_button 'Create collection template'
    click_button 'Next Step'
    click_button 'Next Step'
    check 'collection_template_auto_clean'
    click_button 'Next Step'
    find('#map').double_click
    find('#map').double_click
    click_button 'Add template of cropped area'
    click_button 'Next Step'
    click_button 'Next Step'
    all('.media-body')[1].click
    click_button 'Next Step'
    click_button 'Next Step'
  end
  after do
    ActiveJob::Base.queue_adapter = :test
  end
  it 'Should display the results of the post process step' do
    expect(page).to have_css 'h1', text: 'Build the graph'
    expect(page).to have_css '#map'
  end
  it 'Should display the form for the graph building step' do
    meth_finder = 'select[name="collection_template[graph]'\
      '[simplification-method]"] option'
    format_finder = 'select[name="collection_template[graph]'\
      '[format]"] option'
    pm_finder = 'select[name="collection_template[graph]'\
      '[pathfinding-method]"] option'
    expect(page).to have_css 'select', count: 3
    expect(page).to have_css meth_finder, count: 2
    expect(page).to have_css format_finder, count: 5
    expect(page).to have_css pm_finder, count: 2
    expect(page).to have_css 'input[type="range"]', count: 1
  end
  it 'clicks through the next step without error' do
    ActiveJob::Base.queue_adapter = :test
    click_button 'Next Step'
  end
end
