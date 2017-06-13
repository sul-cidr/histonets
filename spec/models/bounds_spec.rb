# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bounds do
  subject { described_class.new(x1: 100, y1: 90, x2: 25, y2: 50) }

  describe '.from_array' do
    it do
      expect(described_class.from_array([[100, 90], [25, 50]])).to eq subject
    end
  end
  describe '#to_xywh' do
    it { expect(subject.to_xywh).to eq '25,50,75,40' }
  end
  describe '#x_max' do
    it { expect(subject.x_max).to eq 100 }
  end
  describe '#x_min' do
    it { expect(subject.x_min).to eq 25 }
  end
  describe '#y_max' do
    it { expect(subject.y_max).to eq 90 }
  end
  describe '#y_min' do
    it { expect(subject.y_min).to eq 50 }
  end
  describe '#width' do
    it { expect(subject.width).to eq 75 }
  end
  describe '#height' do
    it { expect(subject.height).to eq 40 }
  end
end
