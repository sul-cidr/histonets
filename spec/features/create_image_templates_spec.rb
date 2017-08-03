# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create image templates', type: :feature, js: true do
  before do
    image = create(:image, file_name: 'small_map.jpg')
    create(:collection, images: [image])
    visit collections_path
    click_button 'Create collection template'
    click_button 'Next Step'
    click_button 'Next Step'
    check 'collection_template_auto_clean'
    click_button 'Next Step'
  end
  it 'has image templates listed and are persisted' do
    expect(page).to have_css '.image-template-list'
    click_button 'Add template of cropped area'
    expect(page).to have_css 'li img[src*="0,0,300,300"]'
    expect(page).to have_css 'img'
    finder = '//input[@name="collection_template[image_templates_attributes][]'\
      '[match_options][threshold]"]'
    find(:xpath, finder).set 100
    click_button 'Next Step'
    last = ImageTemplate.last
    expect(last.image_url).to match(/0,0,300,300/)
    expect(last.match_options['threshold']).to eq '100'
    page.go_back
    expect(page).to have_css '.image-template-list li', count: 1
  end
  it 'persists the threhold during creation of another template' do
    click_button 'Add template of cropped area'
    input = '//input[@name="collection_template[image_templates_attributes][]'\
      '[match_options][threshold]"]'
    find(:xpath, input).set '100'
    click_button 'Add template of cropped area'
    expect(page).to have_css("input[value='100']")
  end
  it 'enqueues the histogram calculation' do
    click_button 'Add template of cropped area'
    ActiveJob::Base.queue_adapter = :test
    expect do
      click_button 'Next Step'
    end.to have_enqueued_job(CalculateHistogramJob)
  end
end
