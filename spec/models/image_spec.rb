# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'does not have to belong to a collection' do
    expect(create(:image)).to be_an described_class
  end
  it 'can belong to many collections' do
    expect(create(:image_with_collections).collections.length).to eq 3
  end
  describe '.from_file_path' do
    it 'creates an Image' do
      expect(described_class.from_file_path('/dev/null/awesome.jpg'))
        .to be_an described_class
    end
    it 'creates an Image with file_name correctly' do
      expect(described_class.from_file_path('/dev/null/awesome.jpg').file_name)
        .to eq 'awesome.jpg'
    end
  end
end
