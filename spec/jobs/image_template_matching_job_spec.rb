# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImageTemplateMatchingJob, type: :job do
  describe '#perform' do
    let(:collection_template) do
      create(:collection_template,
             image: create(:image, file_name: 'eddie.jpg'),
             auto_clean: true)
    end
    it 'calls appropriate method on the collection_template' do
      expect(collection_template).to receive(:create_image_template_matches)
      subject.perform(collection_template)
    end
  end
end
