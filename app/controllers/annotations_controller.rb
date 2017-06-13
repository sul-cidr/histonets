# frozen_string_literal: true

##
# Controller for Annotations resources
class AnnotationsController < ApplicationController
  before_action :set_collection_template

  def index; end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_collection_template
    @collection_template = CollectionTemplate.find(
      params[:collection_template_id]
    )
  end
end
