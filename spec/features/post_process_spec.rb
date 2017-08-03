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
    check 'collection_template_auto_clean'
    click_button 'Next Step'
    # Click somewhere on the map to zoom in
    find('#map').double_click
    click_button 'Add template of cropped area'
    click_button 'Next Step'
    click_button 'Next Step'
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
  it 'Should provide the ridge form' do
    instruction = 'Select parameters for removing ridges from the map'
    width_finder = 'input[name="collection_template[ridges]'\
      '[width]"]'
    th_finder = 'input[name="collection_template[ridges]'\
        '[threshold]"]'
    dil_finder = 'input[name="collection_template[ridges]'\
      '[dilation]"]'
    enabled_finder = 'input[name="collection_template[enabled_options]'\
      '[ridges]"]'
    within('.ridges') do
      expect(page).to have_css 'h4', text: instruction
      expect(page).to have_css width_finder
      expect(page).to have_css th_finder
      expect(page).to have_css dil_finder
      expect(page).to have_css 'input[type="range"]', count: 3
      expect(page).to have_css '.switch-light'
      expect(page).to have_css 'input[type="checkbox"]', visible: false
      expect(page).to have_css enabled_finder, visible: false
    end
  end
  it 'Should enable ridge ranges when the toggle is clicked' do
    expect(page).to have_css 'input[type="range"][disabled]', count: 3
    find('[for="ridges_enabled"]').click
    expect(page).not_to have_css 'input[type="range"][disabled]'
  end
  it 'Should provide the skeletonize form' do
    bin_finder = 'select[name="collection_template[skeletonize]'\
      '[binarization-method]"] option'
    mode_finder = 'select[name="collection_template[skeletonize]'\
      '[method]"] option'
    instruction = 'Select parameters for extracting the skeleton'
    within('.skeletonize') do
      expect(page).to have_css 'h4', text: instruction
      expect(page).to have_css 'select', count: 2
      expect(page).to have_css mode_finder, count: 5
      expect(page).to have_css bin_finder, count: 4
      expect(page).to have_css 'input[type="range"]', count: 1
    end
  end
end
