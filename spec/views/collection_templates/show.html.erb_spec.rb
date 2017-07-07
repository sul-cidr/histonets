# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collection_templates/show', type: :view do
  before do
    assign(:collection_template, create(:collection_template))
  end

  it 'renders process image link' do
    render
    expect(rendered)
      .to have_css 'a.btn.btn-warning[data-confirm="Are you sure? This process'\
      ' can take a long time."]', text: 'Process Images in this Collection'
  end
end
