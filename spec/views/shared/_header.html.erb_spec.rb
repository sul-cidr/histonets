# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_header', type: :view do
  it 'renders the brand' do
    render
    expect(rendered).to have_css 'a.brand', text: 'Histonets'
  end
  it 'renders the nav links' do
    render
    expect(rendered).to have_css 'div.nav-item'
    expect(rendered).to have_css 'a.nav-link'
  end
end
