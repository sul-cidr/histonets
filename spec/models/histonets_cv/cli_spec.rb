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
