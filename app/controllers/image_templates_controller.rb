# frozen_string_literal: true

##
# Controller for ImageTemplates within a nested CollectionTemplate
class ImageTemplatesController < ApplicationController
  before_action :set_image_template

  def edit; end

  def update
    @image_template.update(image_template_params.merge(status: true))
    if !@image_template.collection_template.unverified_image_templates.empty?
      redirect_to edit_collection_template_image_template_path(
        @image_template.collection_template,
        @image_template.collection_template.unverified_image_templates.first
      )
    else
      ##
      # When no more unverified_image_templates remain, redirect back to the
      # step after `edit_image_templates`
      return_to_next_collection_template_builder
    end
  end

  def destroy
    @image_template.destroy
    respond_to do |format|
      format.html do
        return_to_image_template_builder
      end
      format.json { head :no_content }
    end
    # return_to_image_template_builder
  end

  private

  def return_to_next_collection_template_builder
    redirect_to collection_template_build_path(
      @image_template.collection_template,
      CollectionTemplate.form_steps[CollectionTemplate.form_steps.index('edit_image_templates') + 1]
    )
  end

  def return_to_image_template_builder
    redirect_to collection_template_build_path(
      @image_template.collection_template,
      'create_image_templates'
    )
  end

  def image_template_params
    permitted_attributes = {
      match_options: [:threshold, :rotation, :elasticity]
    }
    params.require(:image_template).permit(:id, permitted_attributes)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_image_template
    @image_template = ImageTemplate.find(params[:id])
  end
end
