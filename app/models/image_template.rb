# frozen_string_literal: true

##
# Model that holds the ImageTemplate attributes and logic
class ImageTemplate < ApplicationRecord
  belongs_to :collection_template
  serialize :match_options, Hash
  serialize :masks
end
