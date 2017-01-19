# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageTemplatesController, type: :controller do
  describe 'DELETE destroy' do
    let(:collection_template) { create(:collection_template) }
    # Need to figure out which method to create image template on the collection template
    it 'destroys @image_template' do
      delete :destroy, params: { id: image_template.id }
      expect { image_template.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
