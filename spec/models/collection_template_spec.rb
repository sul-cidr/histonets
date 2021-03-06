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
          select_image
          auto_clean
          crop_image
          image_clean
          review_template_match_results
          create_image_paths
          post_process_image_paths
          build_graph
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
               '{"action":"brightness","options":{"value":22}}]'
    end
  end
  describe '#cleaned_image' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg'),
        image_clean: { contrast: 40, brightness: 22 },
        crop_bounds: [0, 0, 100, 100]
      )
    end
    it 'returns the cleaned image file_name' do
      expect(subject.cleaned_image)
        .to match(/small_map_.*_tmp/)
    end
  end
  describe '#pathselected_image' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg'),
        image_paths: ['255,255,255', '0,0,0']
      )
    end
    it 'concatenates fingerprint_pathselection, file_name, and tmp' do
      expect(subject.pathselected_image)
        .to eq 'small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396_ffffff_000000_tmp'
    end
  end
  describe '#fingerprint_pathselection' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg'),
        image_paths: ['255,255,255', '0,0,0']
      )
    end
    it 'concatenates fingerprint and hex path selections' do
      expect(subject.fingerprint_pathselection)
        .to eq '0be5efdb4c9b1d2b1ec690cf6b9bc396_ffffff_000000'
    end
  end
  describe 'postprocessed_image' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg')
      )
    end
    it 'generates a new filename for the output of the postprocess step' do
      expect(subject.postprocessed_image)
        .to eq 'small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess_tmp'
    end
  end
  describe 'fingerprint_postprocessed' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg')
      )
    end
    it 'concatenates pathselected fingerprint and postprocess' do
      expect(subject.fingerprint_postprocessed)
        .to eq '0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess'
    end
  end
  describe 'postprocessed_image_url' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg')
      )
    end
    it 'creates a RIIIF URL to the output of the postprocess step' do
      expect(subject.postprocessed_image_url)
        .to eq(
          'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess_tmp/full/full/0/default.png'
        )
    end
  end
  describe 'post_process_params' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             skeletonize: {
               'method' => 'combined',
               'dilation' => 13,
               'binarization-method' => 'li',
               'invert' => 'true'
             },
             ridges: {
               'width' => 6,
               'threshold' => 128,
               'dilation' => 3
             },
             blobs: {
               'maximum-area' => 100,
               'threshold' => 128,
               'connectivity' => 8
             },
             enabled_options: {
               'ridges' => 'true',
               'blobs' => 'true'
             })
    end
    it 'properly formats skeletonize params' do
      expect(subject.skeletonize_params).to eq(
        'method' => 'combined',
        'dilation' => 13,
        'binarization-method' => 'li',
        'invert' => 'true'
      )
    end
    it 'properly formats ridges params' do
      expect(subject.ridges_params).to eq(
        'width' => 6, 'threshold' => 128, 'dilation' => 3
      )
    end
    it 'properly formats blobs params' do
      expect(subject.blobs_params).to eq(
        'maximum-area' => 100, 'threshold' => 128, 'connectivity' => 8
      )
    end
    context 'with ridges enabled' do
      it 'properly formats postprocess params' do
        subject.enabled_options['blobs'] = 'false'
        expect(subject.postprocess_params_to_formal_json).to eq(
          '[{"action":"ridges","options":{"width":6,"threshold":128,"dilation"'\
          ':3}},{"action":"skeletonize","options":{"method":"combined",'\
          '"dilation":13,"binarization-method":"li","invert":"true"}}]'
        )
      end
    end
    context 'with ridges disabled' do
      it 'properly formats postprocess params' do
        subject.enabled_options['ridges'] = 'false'
        subject.enabled_options['blobs'] = 'false'
        expect(subject.postprocess_params_to_formal_json).to eq(
          '[{"action":"skeletonize","options":{"method":"combined",'\
          '"dilation":13,"binarization-method":"li","invert":"true"}}]'
        )
      end
    end
    context 'with blobs enabled' do
      it 'properly formats postprocess params' do
        subject.enabled_options['ridges'] = 'false'
        expect(subject.postprocess_params_to_formal_json).to eq(
          '[{"action":"blobs","options":{"maximum-area":100,"threshold":128,'\
          '"connectivity":8}},{"action":"skeletonize","options":{"method":'\
          '"combined","dilation":13,"binarization-method":"li","invert":'\
          '"true"}}]'
        )
      end
    end
    context 'with blobs disabled' do
      it 'properly formats postprocess params' do
        subject.enabled_options['ridges'] = 'false'
        subject.enabled_options['blobs'] = 'false'
        expect(subject.postprocess_params_to_formal_json).to eq(
          '[{"action":"skeletonize","options":{"method":"combined",'\
          '"dilation":13,"binarization-method":"li","invert":"true"}}]'
        )
      end
    end
  end
  describe 'pathselected_image_url' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'creates a RIIIF URL to the output of the requisite step' do
      expect(subject.pathselected_image_url)
        .to eq 'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396__tmp/full/full/0/default.png'
    end
  end
  describe 'enhance_params' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'properly formats enhance params' do
      expect(subject.enhance_params).to eq("-p '[[255, 255, 255]"\
      ", [254, 254, 254]]'")
    end
  end
  describe '#image_paths_to_hex' do
    subject do
      create(
        :collection_template,
        image: create(:image, file_name: 'small_map.jpg'),
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
        image: create(:image, file_name: 'small_map.jpg'),
        image_clean: { contrast: 40, brightness: 22 },
        crop_bounds: [0, 0, 100, 100]
      )
    end
    it 'returns a MD5 hashed value of name, crop_bounds, and image_clean' do
      expect(subject.fingerprinted_name)
        .to eq '39d56e891a394551a45fcdba843b64d8'
    end
  end
  describe '#cropped_image' do
    context 'when no crop_bounds' do
      subject do
        create(
          :collection_template,
          image: create(:image, file_name: 'small_map.jpg'),
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
          image: create(:image, file_name: 'small_map.jpg'),
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
        image: create(:image, file_name: 'small_map.jpg')
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
  describe '#process_all_images' do
    let(:collection) { create(:collection_with_images) }
    subject do
      create(:collection_template, collection: collection)
    end
    it 'enqueues a ProcessImageJob for all images in a collection' do
      subject.process_all_images
      expect(ProcessImageJob)
        .to have_been_enqueued.at_least(collection.images.count).times
    end
  end
  describe '#palette' do
    subject do
      create(:collection_template)
    end
    it 'creates string used by histonets-cv' do
      c = Collection.find(subject.collection_id)
      c.palette = '[[255, 255, 255], [254, 254, 254]]'
      expect(subject.palette)
        .to eq '[[255, 255, 255], [254, 254, 254]]'
    end
  end
  describe '#palette_params' do
    subject do
      create(
        :collection_template
      )
    end
    it 'creates string used by histonets-cv if posterize is on' do
      subject.image_clean = { posterize: 3, posterize_method: 'linear' }
      expect(subject.palette_params)
        .to eq '-c 3 -m linear'
    end
    it 'returns an empty string if posterize is off' do
      expect(subject.palette_params).to eq ''
    end
  end
  describe '#posterize_params' do
    subject do
      create(
        :collection_template,
        image_clean: { posterize: 3, posterize_method: 'linear' }
      )
    end
    it 'creates string used by histonets-cv' do
      c = Collection.find(subject.collection_id)
      c.palette = '[[255, 255, 255], [254, 254, 254]]'
      expect(subject.posterize_params)
        .to eq "-p '#{subject.palette}' -m linear 3"
    end
  end
  describe 'partial_clean_image_url' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'creates a RIIIF URL to the output of the requisite step' do
      expect(subject.partial_clean_image_url)
        .to eq 'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396_partial_tmp/full/full/0/default.png'
    end
  end
  describe 'fingerprinted_partial_clean_name' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'creates a RIIIF URL to the output of the requisite step' do
      expect(subject.fingerprinted_partial_clean_name)
        .to eq '0be5efdb4c9b1d2b1ec690cf6b9bc396_partial'
    end
  end
  describe 'partial_clean_image' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'creates a RIIIF URL to the output of the requisite step' do
      expect(subject.partial_clean_image)
        .to eq 'small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396_partial_tmp'
    end
  end
  describe '#graph_params' do
    subject do
      create(
        :collection_template,
        graph: {
          'simplification-method' => 'vw',
          'simplification-tolerance' => 0,
          'format' => 'graphml',
          'pathfinding-method' => 'astar'
        },
        image_matches: [[[0, 0], [5, 5]], [[1, 1], [6, 6]]]
      )
    end
    it 'creates string used by histonets-cv' do
      expect(subject.graph_params)
        .to eq "'[[[0, 0], [5, 5]], [[1, 1], [6, 6]]]' -sm vw -st 0 -f"\
        ' graphml -pm astar'
    end
  end
  describe '#graph_name' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'))
    end
    it 'creates the proper name for the graph output' do
      expect(subject.graph_name)
        .to eq '0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess_graph'
    end
  end
  describe '#graph_url' do
    subject do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             graph: { 'format' => 'graphml' })
    end
    it 'creates the proper path for the graph data' do
      expect(subject.graph_url)
        .to eq 'spec/fixtures/data/0be5efdb4c9b1d2b1ec690cf6b9bc396__'\
          'postprocess_graph.graphml'
    end
  end
end
