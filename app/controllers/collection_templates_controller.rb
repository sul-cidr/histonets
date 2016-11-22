# frozen_string_literal: true

##
# Controller for CollectionTemplate resources
class CollectionTemplatesController < ApplicationController
  before_action :set_collection_template, only: [:show, :edit, :update, :destroy]

  # GET /collection_templates
  # GET /collection_templates.json
  def index
    @collection_templates = CollectionTemplate.all
  end

  # GET /collection_templates/1
  # GET /collection_templates/1.json
  def show
  end

  # GET /collection_templates/new
  def new
    @collection_template = CollectionTemplate.new
  end

  # GET /collection_templates/1/edit
  def edit
  end

  # POST /collection_templates
  # POST /collection_templates.json
  def create
    @collection_template = CollectionTemplate.new(collection_template_params)

    respond_to do |format|
      if @collection_template.save
        format.html { redirect_to @collection_template, notice: 'Collection template was successfully created.' }
        format.json { render :show, status: :created, location: @collection_template }
      else
        format.html { render :new }
        format.json { render json: @collection_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collection_templates/1
  # PATCH/PUT /collection_templates/1.json
  def update
    respond_to do |format|
      if @collection_template.update(collection_template_params)
        format.html { redirect_to @collection_template, notice: 'Collection template was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection_template }
      else
        format.html { render :edit }
        format.json { render json: @collection_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collection_templates/1
  # DELETE /collection_templates/1.json
  def destroy
    @collection_template.destroy
    respond_to do |format|
      format.html { redirect_to collection_templates_url, notice: 'Collection template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_template
      @collection_template = CollectionTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_template_params
      params.fetch(:collection_template, {})
    end
end
