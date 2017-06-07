# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Manifests/Annotations requests' do
  describe 'provides a JSON response' do
    before do
      image = create(:image, file_name: 'eddie.jpg')
      create(:collection, images: [image])
      matches = [[[20, 30], [25, 35]], [[40, 60], [50, 75]]]
      create(
        :collection_template,
        image: image,
        image_matches: matches
      )
      allow_any_instance_of(CollectionTemplate).to receive(:cleaned_image)
        .and_return('eddie')
    end
    describe 'manifest' do
      before do
        get '/collection_templates/1/build/review_template_match_results.json'
      end
      it 'status' do
        expect(status).to eq 200
      end
      it 'manifest label' do
        body = JSON.parse(response.body)
        expect(body['label']).to eq 'Histonets - Collection Template 1'
      end
      it 'sequence / canvas' do
        body = JSON.parse(response.body)
        canvas = body['sequences'][0]['canvases'][0]
        expect(canvas['width']).to eq 3024
        expect(canvas['height']).to eq 4032
      end
      it 'images' do
        body = JSON.parse(response.body)
        canvas = body['sequences'][0]['canvases'][0]
        image = canvas['images'][0]
        expect(image['on']).to eq canvas['@id']
        expect(image['resource']['width']).to eq 3024
        expect(image['resource']['height']).to eq 4032
        expect(image['resource']['@id'])
          .to eq image['resource']['service']['@id']
      end
      it 'other content' do
        body = JSON.parse(response.body)
        canvas = body['sequences'][0]['canvases'][0]
        other_content = canvas['otherContent'][0]
        resource = other_content['resources'][0]
        expect(other_content['@id'])
          .to eq 'http://localhost:1337/collection_templates/1/annotations'
        expect(resource['@id']).to eq '0#xywh=20,30,5,5'
        expect(resource['on'])
          .to eq 'http://localhost:1337/collection_templates/1#xywh=20,30,5,5'
        expect(resource['resource']['chars']).to eq 'Image Template Match'
      end
    end
    describe 'annotations' do
      before do
        get '/collection_templates/1/annotations.json'
      end
      it 'status' do
        expect(status).to eq 200
      end
      it 'contains annotation information' do
        other_content = JSON.parse(response.body)
        resource = other_content['resources'][0]
        expect(other_content['@id'])
          .to eq 'http://localhost:1337/collection_templates/1/annotations'
        expect(resource['@id']).to eq '0#xywh=20,30,5,5'
        expect(resource['on'])
          .to eq 'http://localhost:1337/collection_templates/1#xywh=20,30,5,5'
        expect(resource['resource']['chars']).to eq 'Image Template Match'
      end
    end
  end
end
