# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildGraphJob, type: :job do
  let(:cli_instance) { instance_double(HistonetsCv::Cli) }
  before do
    allow(HistonetsCv::Cli).to receive(:new).and_return(cli_instance)
  end
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'small_map.jpg'),
             graph: {
               'simplification-method' => 'vw',
               'simplification-tolerance' => 0,
               'format' => 'graphml',
               'pathfinding-method' => 'astar'
             },
             image_matches: [[[0, 0], [5, 5]], [[1, 1], [6, 6]]])
    end
    it 'calls the HistonetsCv::Cli graph' do
      expect(cli_instance).to receive(:graph)
        .with("'[[[0, 0], [5, 5]], [[1, 1], [6, 6]]]' -sm vw -st 0 -f graphml"\
              ' -pm astar',
              '0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess_graph',
              'graphml',
              'http://localhost:1337/image-service/small_map_0be5efdb4c9b1d2b1ec690cf6b9bc396__postprocess_tmp/full/full/0/default.png')
      subject.perform(collection_template)
    end
  end
end
