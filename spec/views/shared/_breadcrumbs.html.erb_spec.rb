# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'shared/_breadcrumbs', type: :view do
  before do
    without_partial_double_verification do
      view_methods = {
        wizard_steps: %w[step_1 step_2 step_3 step_4],
        step: 'step_3',
        wizard_path: 'i_am_a_url_path_to_a_step_page'
      }
      expect(view).to receive_messages(view_methods)
      allow(view).to receive(:past_step?).with('step_1').and_return(true)
      allow(view).to receive(:past_step?).with('step_2').and_return(true)
      allow(view).to receive(:past_step?).with('step_3').and_return(false)
      allow(view).to receive(:past_step?).with('step_4').and_return(false)
    end
  end

  it 'renders the breadcrumbs list' do
    render
    expect(rendered).to have_css 'ul', id: 'breadcrumbs'
  end
  it 'renders the links with next and previous steps styled differently' do
    render
    expect(rendered).to have_css 'li.finished'
    expect(rendered).to have_css 'li.current'
    expect(rendered).to have_css 'li.unfinished'
  end
end
