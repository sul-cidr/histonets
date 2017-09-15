# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistonetsCv::Cli, type: :model do
  subject { described_class.new('yolo.jpg') }
  context 'incorrect usage' do
    it 'raises an error' do
      expect { subject.contrast("'yolo'") }
        .to raise_error(
          HistonetsCv::Exceptions::CliError, /yolo is not a valid integer/
        )
    end
  end
  describe '#contrast' do
    subject { described_class.new('yolo.jpg') }
    it 'executes the contrast command with arguments' do
      expect(subject).to receive(:execute)
        .with('contrast 42 spec/fixtures/images/yolo.jpg -o '\
              'spec/fixtures/images/yolo_contrast_tmp.png')
      subject.contrast(42)
    end
  end
  describe '#brightness' do
    subject { described_class.new('yolo.jpg') }
    it 'executes the brightness command with arguments' do
      expect(subject).to receive(:execute)
        .with('brightness 42 spec/fixtures/images/yolo.jpg -o '\
              'spec/fixtures/images/yolo_brightness_tmp.png')
      subject.brightness(42)
    end
  end
  describe '#pipeline' do
    subject { described_class.new('yolo.jpg') }
    let(:arguments) do
      [
        {
          action: 'contrast',
          options: {
            value: 55
          }
        }
      ].to_json
    end
    it 'executes the pipeline command with json arguments' do
      expect(subject).to receive(:execute)
        .with("pipeline '#{arguments}' spec/fixtures/images/yolo.jpg "\
              '-o spec/fixtures/images/yolo__tmp.png')
      subject.pipeline(arguments)
    end
  end
  describe '#enhance' do
    subject { described_class.new('yolo.png') }
    let(:arguments) do
      [' -p "[[255, 255, 255], [254, 254, 254]]"',
       'spec/fixtures/images/yolo.png']
    end
    it 'executes the enhance command with arguments' do
      expect(subject).to receive(:execute)
        .with("enhance #{arguments[0]} #{arguments[1]} -o "\
          'spec/fixtures/images/yolo_spec/fixtures/images/yolo.png_tmp.png')
      subject.enhance(*arguments)
    end
  end
  describe '#match' do
    subject { described_class.new('yolo.jpg') }
    let(:arguments) { 'http://test -th 8' }
    it 'executes the match command with arguments' do
      expect(subject).to receive(:execute)
        .with("match #{arguments} spec/fixtures/images/yolo.jpg")
      subject.match(arguments)
    end
  end
  describe '#select' do
    subject { described_class.new('yolo.jpg') }
    let(:arguments) { [[123, 45, 67], 'holla'] }
    it 'executes the select command with arguments' do
      expect(subject).to receive(:execute)
        .with("select #{arguments[0]} spec/fixtures/images/yolo.jpg "\
              '-o spec/fixtures/images/yolo_holla_tmp.png')
      subject.select(*arguments)
    end
  end
  describe '#skeletonize' do
    subject { described_class.new('yolo.jpg') }
    let(:arguments) do
      [' -m combined -d 13 -b li',
       'spec/fixtures/images/yolo_tmp.png',
       'spec/fixtures/images/yolo.png']
    end
    it 'executes the skeletonize command with arguments' do
      expect(subject).to receive(:execute)
        .with("skeletonize #{arguments[0]}"\
              ' spec/fixtures/images/yolo.png'\
              ' -o spec/fixtures/images/yolo_spec'\
              '/fixtures/images/yolo_tmp.png_tmp.png')
      subject.skeletonize(*arguments)
    end
  end
  describe '#ridges' do
    subject { described_class.new('yolo.jpg') }
    let(:arguments) do
      [' -w 6 -th 128 -d 3',
       'spec/fixtures/images/yolo_tmp.png',
       'spec/fixtures/images/yolo.png']
    end
    it 'executes the ridges command with arguments' do
      expect(subject).to receive(:execute)
        .with("ridges #{arguments[0]}"\
              ' spec/fixtures/images/yolo.png'\
              ' -o spec/fixtures/images/yolo_spec'\
              '/fixtures/images/yolo_tmp.png_tmp.png')
      subject.ridges(*arguments)
    end
  end
  describe '#palette' do
    subject { described_class.new }
    let(:arguments) do
      [' -m kmeans',
       'spec/fixtures/data/collection_1_histogram.txt']
    end
    it 'executes the palette command with arguments' do
      expect(subject).to receive(:execute)
        .with("palette #{arguments[0]} #{arguments[1]}")
      subject.palette(*arguments)
    end
  end
  describe '#posterize' do
    subject { described_class.new }
    let(:arguments) do
      [' -m kmeans -p "[[255, 255, 255], [254, 254, 254]]" 2',
       'yolo_tmp.png',
       'yolo.jpg']
    end
    it 'executes the posterize command with arguments' do
      expect(subject).to receive(:execute)
        .with("posterize #{arguments[0]} #{arguments[2]}"\
          ' -o spec/fixtures/images/_yolo_tmp.png_tmp.png')
      subject.posterize(*arguments)
    end
  end
  describe '#graph' do
    subject { described_class.new }
    let(:arguments) do
      ["'[[[0, 0], [5, 5]], [[1, 1], [6, 6]]]' -sm vw -st 0 -f graphml",
       'yolo_tmp',
       'graphml',
       'yolo.jpg']
    end
    it 'executes the graph command with arguments' do
      expect(subject).to receive(:execute)
        .with("graph #{arguments[0]} #{arguments[3]}"\
          ' -o spec/fixtures/data/yolo_tmp.graphml')
      subject.graph(*arguments)
    end
  end
  describe '#help' do
    it 'returns help text' do
      expect(subject.help)
        .to match(/Usage: histonets \[OPTIONS\] COMMAND \[ARGS\]\.\.\./)
    end
  end
  describe '#version' do
    it 'returns version number' do
      expect(subject.version).to match(/histonets, version /)
    end
  end
end
