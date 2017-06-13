# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnnotationsController, type: :controller do
  describe 'GET index' do
    let(:collection_template) { create(:collection_template) }

    it 'assigns @collection_template' do
      get :index, params: {
        collection_template_id: collection_template.id, format: :json
      }
      expect(assigns(:collection_template)).to eq collection_template
    end
    it 'renders index' do
      get :index, params: {
        collection_template_id: collection_template.id, format: :json
      }
      expect(response).to render_template('index')
    end
  end
end
