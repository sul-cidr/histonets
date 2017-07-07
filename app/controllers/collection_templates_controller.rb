# frozen_string_literal: true

##
# Controller for CollectionTemplate resources
class CollectionTemplatesController < ApplicationController
  before_action :set_collection_template, only: %i[show destroy process_images]

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

  # POST /collection_templates
  # POST /collection_templates.json
  def create
    @collection_template = CollectionTemplate.new
    @collection_template.save(validate: false)
    redirect_to collection_template_build_path(
      @collection_template, CollectionTemplate.form_steps.first
    )
  end

  # DELETE /collection_templates/1
  # DELETE /collection_templates/1.json
  def destroy
    @collection_template.destroy
    respond_to do |format|
      format.html do
        redirect_to collection_templates_url,
                    notice: 'Collection template was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def process_images
    @collection_template.process_all_images
    respond_to do |format|
      format.html { redirect_to @collection_template }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection_template
    @collection_template = CollectionTemplate.find(params[:id])
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def collection_template_params
    params
      .require(:collection_template)
      .permit(:collection_id, :image_id)
  end
end
