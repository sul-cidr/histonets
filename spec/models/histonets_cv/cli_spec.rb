# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HistonetsCv::Cli, type: :model do
  describe '#contrast' do
    subject { described_class.new('yolo.jpg') }
    it 'executes the contrast command with arguments' do
      expect(subject).to receive(:execute)
        .with('contrast 42 file://./spec/fixtures/images/yolo.jpg -o '\
              './spec/fixtures/images/yolo_contrast_tmp.jpg')
      subject.contrast(42)
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
