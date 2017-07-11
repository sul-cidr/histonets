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
  it 'renders a form to create collection templates' do
    @collection = Collection.create! valid_attributes
    render
    expect(rendered).to have_css 'form.edit_collection'
    expect(rendered).to have_css '#collection_collection_id', visible: false
    expect(rendered).to have_selector("input[value='1']", visible: false)
  end
  describe 'a collection without images' do
    it 'lets the user know there are no images' do
      @collection = create(:collection)
      render
      expect(rendered).to have_content(
        'There are currently no images associated with this collection.'
      )
    end
  end
  describe 'a collection with images' do
    before do
      @collection = create(:collection_with_images)
    end
    it 'renders images associated with the collection' do
      render
      expect(rendered).to have_css 'div.collection-image'
    end
    it 'renders the name of each image' do
      render
      expect(rendered).to have_css 'div.image-name'
    end
  end
end
