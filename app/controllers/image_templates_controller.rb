# frozen_string_literal: true

##
# Controller for ImageTemplates within a nested CollectionTemplate
class ImageTemplatesController < ApplicationController
  before_action :set_image_template

  def destroy
    @image_template.destroy
    respond_to do |format|
      format.html do
        return_to_image_template_builder
      end
      format.json { head :no_content }
    end
  end

  private

  def return_to_image_template_builder
    redirect_to collection_template_build_path(
      @image_template.collection_template,
      'create_image_templates'
    )
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_image_template
    @image_template = ImageTemplate.find(params[:id])
  end
end
