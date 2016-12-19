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
    case step
    when 'image_clean'
      skip_step if @collection_template.auto_clean
    end
    render_wizard
  end

  # PUT/PATCH /collection_templates/:collection_template_id/build/:id
  def update
    @collection_template.update(collection_template_params(step))
    case step
    when 'auto_clean'
      ImageEnhanceJob.new.perform(@collection_template)
    when 'image_clean'
      ImageCleanJob.new.perform(@collection_template)
    end
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
                           when 'crop_image'
                             [:crop_bounds]
                           when 'auto_clean'
                             [:auto_clean]
                           when 'image_clean'
                             {
                               image_clean: [
                                 :denoise, :equalize, :brightness, :contrast,
                                 :smooth, :posterize, :posterize_method
                               ]
                             }
                           when 'create_image_templates'
                             {
                               image_templates_attributes: [:image_url, :id]
                             }
                           end
    params.require(:collection_template)
          .permit(permitted_attributes).merge(form_step: step)
  end
end
