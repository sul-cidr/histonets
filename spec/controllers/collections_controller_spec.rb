# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do
  let(:valid_attributes) do
    {
      name: 'Test collection',
      description: 'Test description'
    }
  end
  let(:invalid_attributes) do
    {
      name: nil
    }
  end
  describe 'GET index' do
    let(:collections) { create_list(:collection, 5) }
    it 'assigns all collections as @collections' do
      collection = Collection.create! valid_attributes
      get :index, params: {}
      expect(assigns(:collections)).to eq([collection])
    end
    it 'renders index' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET show' do
    let(:collection) { Collection.create! valid_attributes }
    it 'assigns @collection' do
      get :show, params: { id: collection.id }
      expect(assigns(:collection)).to eq collection
    end
    it 'renders show' do
      get :show, params: { id: collection.id }
      expect(response).to render_template('show')
    end
  end

  describe 'GET new' do
    it 'assigns a new collection as @collection' do
      get :new
      expect(assigns(:collection)).to be_a_new Collection
    end
    it 'renders new' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST create' do
    it 'creates a collection' do
      expect do
        post :create, params: { collection: valid_attributes }
      end.to change(Collection, :count).by(1)
    end
    it 'assigns @collection' do
      post :create, params: { collection: valid_attributes }
      expect(assigns(:collection)).to be_an Collection
      expect(assigns(:collection)).to be_persisted
    end
    it 'persists the correct data' do
      post :create, params: { collection: valid_attributes }
      collection = assigns(:collection)
      expect(collection.name).to eq valid_attributes[:name]
      expect(collection.description).to eq valid_attributes[:description]
    end
    it 'redirects to collections index' do
      post :create, params: { collection: valid_attributes }
      expect(subject).to redirect_to(collections_path)
    end
    it 'redirects to new collection form with invalid attributes' do
      post :create, params: { collection: invalid_attributes }
      expect(response).to render_template('new')
    end
  end

  describe 'GET edit' do
    it 'assigns the requested collection as @collection' do
      collection = Collection.create! valid_attributes
      get :edit, params: { id: collection.id }
      expect(assigns(:collection)).to eq(collection)
    end
  end

  describe 'PATCH/PUT update' do
    let(:new_attributes) { { name: 'new name' } }
    it 'updates the collection' do
      collection = Collection.create! valid_attributes
      put :update, params: { id: collection.id, collection: new_attributes }
      expect(assigns(:collection).name).to eq 'new name'
    end
    it 'assigns the requested collection as @collection' do
      collection = Collection.create! valid_attributes
      put :update, params: { id: collection.id, collection: new_attributes }
      expect(assigns(:collection)).to eq(collection)
    end
    it 'redirects to the collection' do
      collection = Collection.create! valid_attributes
      put :update, params: { id: collection.id, collection: new_attributes }
      expect(response).to redirect_to(collection)
    end
    it 'redirects to the edit form with invalid attributes' do
      collection = Collection.create! valid_attributes
      put :update, params: { id: collection.id, collection: invalid_attributes }
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    let(:collection) { Collection.create! valid_attributes }
    it 'destroys @collection' do
      delete :destroy, params: { id: collection.id }
      expect { collection.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'redirects to collection index' do
      delete :destroy, params: { id: collection.id }
      expect(subject).to redirect_to collections_path
    end
  end
end
