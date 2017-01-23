# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageTemplate, type: :model do
  let(:collection_template) { create(:collection_template) }
  subject(:with_threshold) do
    create(
      :image_template,
      match_options: { 'threshold' => 5 },
      collection_template: collection_template
    )
  end
  subject(:with_flip) do
    create(
      :image_template,
      match_options: { 'flip' => 5 },
      collection_template: collection_template
    )
  end
  subject(:with_image_url) do
    create(
      :image_template,
      image_url: '/yolo.png',
      collection_template: collection_template
    )
  end
  subject(:with_nothing) do
    create(
      :image_template,
      collection_template: collection_template
    )
  end
  subject(:with_all) do
    create(
      :image_template,
      image_url: '/yolo.png',
      match_options: { 'flip' => 5, 'threshold' => 5 },
      collection_template: collection_template
    )
  end
  describe '#cli_options' do
    it do
      expect(with_all.cli_options)
        .to eq 'http://localhost:1337/yolo.png -th 5 -f 5'
    end
    it { expect(with_nothing.cli_options).to eq '' }
  end
  describe '#threshold' do
    it { expect(with_threshold.threshold).to eq '-th 5' }
    it { expect(with_nothing.threshold).to eq '' }
  end
  describe '#flip' do
    it { expect(with_flip.flip).to eq '-f 5' }
    it { expect(with_nothing.flip).to eq '' }
  end
  describe '#cropped_url' do
    it do
      expect(with_image_url.cropped_url).to eq 'http://localhost:1337/yolo.png'
    end
    it { expect(with_nothing.cropped_url).to eq '' }
  end
end
