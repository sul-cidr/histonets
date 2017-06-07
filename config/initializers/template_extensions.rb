# frozen_string_literal: true

ActionView::Template.register_template_handler(:rb, :source.to_proc)
