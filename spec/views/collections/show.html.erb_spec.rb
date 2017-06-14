# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collections/show', type: :view do
  let(:valid_attributes) do
    {
      name: 'Test collection',
      description: 'Test description'
    }
  end
  it 'renders title as h1' do
    @collection = Collection.create! valid_attributes
    render
    expect(rendered).to have_css 'h1', text: 'Test collection'
  end
end
