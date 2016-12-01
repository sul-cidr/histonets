# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionTemplate, type: :model do
  it 'must belong to a collection' do
    expect { described_class.create! }
      .to raise_error(ActiveRecord::RecordInvalid)
  end
  it 'can have an image' do
    expect(create(:collection_template_with_image).image).to be_an Image
  end
  describe '.form_steps' do
    it 'has implemented steps' do
      expect(described_class.form_steps).to contain_exactly(
        *%w(
          select_collection
          select_image
          crop_image
          image_clean
        )
      )
    end
  end
end
