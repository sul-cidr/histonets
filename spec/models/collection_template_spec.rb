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
          create_image_templates
          select_collection
          select_image
          auto_clean
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
        image_clean: { contrast: 40, brightness: 22, posterize: 3,
                       posterize_method: 'linear' }
      )
    end
    it 'creates json used by histonets-cv' do
      expect(subject.image_clean_to_formal_json)
        .to eq '[{"action":"contrast","options":{"value":40}},'\
               '{"action":"brightness","options":{"value":22}},'\
               '{"action":"posterize","options":{"colors":3,'\
               '"method":"linear"}}]'
    end
  end
  describe '#cleaned_image' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg'),
        image_clean: { contrast: 40, brightness: 22 },
        crop_bounds: [0, 0, 100, 100]
      )
    end
    it 'returns the cleaned image file_name' do
      expect(subject.cleaned_image)
        .to match(/eddie_.*_tmp/)
    end
  end
  describe '#fingerprinted_name' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg'),
        image_clean: { contrast: 40, brightness: 22 },
        crop_bounds: [0, 0, 100, 100]
      )
    end
    it 'returns a MD5 hashed value of name, crop_bounds, and image_clean' do
      expect(subject.fingerprinted_name)
        .to eq '383843602aa6372e03b5343c2ae8c9db'
    end
  end
  describe '#cropped_image' do
    context 'when no crop_bounds' do
      subject do
        create(
          :collection_template,
          image: create(:image, file_name: 'eddie.jpg'),
          image_clean: { contrast: 40, brightness: 22 }
        )
      end
      it 'is not available' do
        expect(subject.cropped_image).to eq ''
      end
    end
    context 'with crop_bounds' do
      subject do
        create(
          :collection_template,
          image: create(:image, file_name: 'eddie.jpg'),
          image_clean: { contrast: 40, brightness: 22 },
          crop_bounds: '0,0,100,100'
        )
      end
      it 'is a url' do
        expect(subject.cropped_image)
          .to match(/.*localhost.*image-service.*100,100/)
      end
    end
  end
end
