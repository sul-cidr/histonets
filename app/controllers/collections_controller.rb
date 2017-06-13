##
# Controller for Collections
class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :destroy]

  # GET /collections
  # GET /collections.json
  def index
    @collections = Collection.all
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
  end

  # GET /collections/new
  def new
    @collection = Collection.new
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params
      .require(:collection)
      .permit(:id)
  end
end
