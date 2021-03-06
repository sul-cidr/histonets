# frozen_string_literal: true

##
# Controller for Collections
class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :destroy, :edit, :update]

  # GET /collections
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  def show; end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  # POST /collections
  def create
    @collection = Collection.new(collection_params)
    if @collection.save
      redirect_to(collections_path)
    else
      render('new')
    end
  end

  # GET /collections/1/edit
  def edit; end

  # PATCH/PUT /collections/1
  def update
    if @collection.update_attributes(collection_params)
      redirect_to(collection_path(@collection))
    else
      render('edit')
    end
  end

  # DELETE /collections/1
  def destroy
    @collection.destroy
    redirect_to(collections_path)
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params
      .require(:collection)
      .permit(:id, :name, :description)
  end
end
