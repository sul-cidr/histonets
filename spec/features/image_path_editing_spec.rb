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
    click_button 'Next Step'
  end
  after do
    ActiveJob::Base.queue_adapter = :test
  end
  it 'Should display the precalculated histograms on the page' do
    expect(page).to have_css '.histogram-color', count: 8
  end
end
