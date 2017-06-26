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
          review_template_match_results
          create_image_paths
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
  describe '#pathselected_image' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg'),
        image_paths: ['255,255,255', '0,0,0']
      )
    end
    it 'concatenates fingerprint_pathselection, file_name, and tmp' do
      expect(subject.pathselected_image)
        .to eq 'eddie_495cfb3737dac34bd5a94c06edd1392c_ffffff_000000_tmp'
    end
  end
  describe '#fingerprint_pathselection' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg'),
        image_paths: ['255,255,255', '0,0,0']
      )
    end
    it 'concatenates fingerprint and hex path selections' do
      expect(subject.fingerprint_pathselection)
        .to eq '495cfb3737dac34bd5a94c06edd1392c_ffffff_000000'
    end
  end
  describe '#image_paths_to_hex' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg'),
        image_paths: ['255,255,255', '0,0,0']
      )
    end
    it 'returns converted RGB to hex values' do
      expect(subject.image_paths_to_hex).to include('ffffff', '000000')
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
        .to eq '5045802809d18d1e73953eeccdf130dd'
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
  describe '#create_image_template_matches' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'eddie.jpg')
      )
    end
    let(:image_templates) do
      create_list(
        :image_template,
        3,
        image_url: '/yolo.png',
        match_options: { 'flip' => 5, 'threshold' => 5 },
        status: true,
        collection_template: subject
      )
    end
    let(:cli_instance) { instance_double(HistonetsCv::Cli) }
    before do
      subject.image_templates = image_templates
      allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
    end
    it 'calls the cli with options' do
      options = Array
                .new(3, 'http://localhost:1337/yolo.png -th 5 -f 5').join(' ')
      expect(cli_instance).to receive(:match)
        .with(options, subject.cleaned_image_url).and_return('[[[0,200]]]')
      subject.create_image_template_matches
      expect(subject.image_matches).to eq [[[0, 200]]]
    end
  end
end
