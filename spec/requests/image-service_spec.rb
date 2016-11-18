require 'rails_helper'

RSpec.describe 'Image service' do
  describe 'provides an info.json response' do
    before do
      get '/image-service/eddie/info.json'
    end
    it 'status' do
      expect(status).to eq 200
    end
    it 'width/height' do
      info = JSON.parse(response.body)
      expect(info['height']).to eq 4032
      expect(info['width']).to eq 3024
    end
  end
  describe 'image tiling' do
    it 'returns an image' do
      get '/image-service/eddie/1536,1536,512,512/256,/0/default.jpg'
      expect(status).to eq 200
      expect(response.content_type).to eq 'image/jpeg'
    end
  end
end
