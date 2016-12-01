# frozen_string_literal: true

##
# Controller responsible for directing step by step CollectionTemplate creation
# Uses Wicked gem for most everything.
class CollectionTemplates::BuildController < ApplicationController
  before_action :set_collection_template, only: [:show, :update]
  include Wicked::Wizard
  steps(*CollectionTemplate.form_steps)

  # GET /collection_templates/:collection_template_id/build/:id
  def show
    render_wizard
  end

  # PUT/PATCH /collection_templates/:collection_template_id/build/:id
  def update
    @collection_template.update(collection_template_params(step))
    render_wizard @collection_template
  end

  def finish_wizard_path
    collection_template_path(@collection_template)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection_template
    @collection_template = CollectionTemplate
                           .find(params[:collection_template_id])
  end

  ##
  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def collection_template_params(step)
    permitted_attributes = case step
                           when 'select_collection'
                             [:collection_id]
                           when 'select_image'
                             [:image_id]
                           when 'image_clean'
                             { image_clean: [:contrast] }
                           when 'crop_image'
                             [:crop_bounds]
                           end
    params.require(:collection_template)
          .permit(permitted_attributes).merge(form_step: step)
  end
end
