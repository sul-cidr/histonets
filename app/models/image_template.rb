# frozen_string_literal: true

##
# Model that holds the ImageTemplate attributes and logic
class ImageTemplate < ApplicationRecord
  belongs_to :collection_template
  serialize :match_options, Hash

  ##
  # A convenient helper method here to put the options together correctly
  # @return [String]
  def cli_options
    [cropped_url, threshold, flip].join(' ').strip
  end

  ##
  # @return [String]
  def threshold
    return '' unless match_options['threshold']
    "-th #{match_options['threshold']}"
  end

  ##
  # @return [String]
  def flip
    return '' unless match_options['flip']
    "-f #{match_options['flip']}"
  end

  ##
  # @return [String]
  def cropped_url
    return '' unless image_url.present?
    "#{Settings.HOST_URL}#{image_url}"
  end
end
