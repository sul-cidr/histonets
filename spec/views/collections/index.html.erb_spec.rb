# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collections/index', type: :view do
  before do
    assign(:collections, create_list(:collection, 2))
  end
  it 'renders a list of collections' do
    render
    expect(rendered).to have_css 'div.collection-item', count: 2
  end
  it 'renders links to edit each collection' do
    render
    expect(rendered).to have_css 'a', text: 'Edit', count: 2
  end
  it 'renders links to delete each collection' do
    render
    expect(rendered).to have_css 'a', text: 'Destroy', count: 2
  end
end
