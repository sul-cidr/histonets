# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionTemplatesController, type: :controller do
  describe 'GET index' do
    let(:collection_templates) { create_list(:collection_template, 5) }
    it 'assigns @collection_templates' do
      get :index
      expect(assigns(:collection_templates)).to eq collection_templates
    end
    it 'renders index' do
      get :index
      expect(response).to render_template('index')
    end
  end
  describe 'GET show' do
    let(:collection_template) { create(:collection_template) }
    it 'assigns @collection_template' do
      get :show, params: { id: collection_template.id }
      expect(assigns(:collection_template)).to eq collection_template
    end
    it 'renders show' do
      get :show, params: { id: collection_template.id }
      expect(response).to render_template('show')
    end
  end
  describe 'GET new' do
    it 'assigns @collection_template' do
      get :new
      expect(assigns(:collection_template)).to be_an CollectionTemplate
    end
    it 'renders new' do
      get :new
      expect(response).to render_template('new')
    end
  end
  describe 'POST create' do
    it 'assigns @collection_template' do
      post :create
      expect(assigns(:collection_template)).to be_an CollectionTemplate
    end
    it 'redirects to collection_template_build' do
      post :create
      expect(subject).to redirect_to(
        collection_template_build_path(
          assigns(:collection_template), 'select_collection'
        )
      )
    end
  end
  describe 'DELETE destroy' do
    let(:collection_template) { create(:collection_template) }
    it 'destroys @collection_template' do
      delete :destroy, params: { id: collection_template.id }
      expect { collection_template.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
    context 'when html' do
      it 'redirects to collection_templates_url' do
        delete :destroy, params: { id: collection_template.id }
        expect(subject).to redirect_to collection_templates_url
      end
    end
    context 'when json' do
      it 'renders nothing' do
        delete :destroy, params: { id: collection_template.id, format: :json }
        expect(response.body).to eq ''
      end
    end
  end
  describe 'POST process_images' do
    let(:collection_template) { create(:collection_template) }
    it 'redirects to show page' do
      post :process_images, params: { id: collection_template.id }
      expect(subject).to redirect_to collection_template_path
    end
  end
end
