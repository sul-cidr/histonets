# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  it 'does not have to have images' do
    expect(create(:collection)).to be_an described_class
  end
  it 'can have many images' do
    expect(create(:collection_with_images).images.length).to eq 5
  end
end
