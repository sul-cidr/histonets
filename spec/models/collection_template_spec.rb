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
  describe '#image_clean_to_formal_json' do
    subject do
      create(
        :collection_template,
        image_clean: { contrast: 40, brightness: 22 }
      )
    end
    it 'creates json used by histonets-cv' do
      expect(subject.image_clean_to_formal_json)
        .to eq '[{"action":"contrast","options":{"value":40}},'\
               '{"action":"brightness","options":{"value":22}}]'
    end
  end
  describe '#cleaned_image' do
    subject do
      create(
        :collection_template_with_image,
        image_clean: { contrast: 40, brightness: 22 }
      )
    end
    it 'returns the cleaned image file_name' do
      expect(subject.cleaned_image)
        .to match(/eddie[0-9]*_ccb65591c6884ca90a0b88ba9ca2ec13_tmp/)
    end
  end
end
