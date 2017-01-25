# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageTemplatesController, type: :controller do
  describe 'DELETE destroy' do
    let(:collection_template) { create(:collection_template) }
    let(:image_templates) do
      create_list(:image_template, 3, collection_template: collection_template)
    end
    before do
      collection_template.image_templates = image_templates
    end
    it 'destroys the ImageTemplate' do
      expect do
        delete :destroy, params: {
          collection_template_id: collection_template.id,
          id: collection_template.image_templates.first.id
        }
      end.to change(ImageTemplate, :count).by(-1)
    end
    it 'removes the reference' do
      expect do
        delete :destroy, params: {
          collection_template_id: collection_template.id,
          id: collection_template.image_templates.first.id
        }
      end.to change { collection_template.image_templates.count }.by(-1)
    end
  end
end
