# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionTemplates::BuildController, type: :controller do
  describe 'GET #show' do
    let(:collection_template) { create(:collection_template) }
    it 'returns http success' do
      get :show, params: {
        id: 'select_collection',
        collection_template_id: collection_template.id
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    let(:collection_template) { create(:collection_template) }
    let(:collection) { create(:collection) }
    it 'redirects to next step' do
      put :update, params: {
        id: 'select_collection',
        collection_template_id: collection_template.id,
        collection_template: {
          collection_id: collection.id
        }
      }
      expect(response).to redirect_to(
        collection_template_build_path(
          assigns(:collection_template), 'select_image'
        )
      )
    end
  end
  describe '#finish_wizard_path' do
    let(:collection_template) { create(:collection_template) }
    it 'returns the collection_template_path' do
      subject.instance_variable_set('@collection_template', collection_template)
      expect(subject.finish_wizard_path)
        .to eq collection_template_path(collection_template)
    end
  end
end
