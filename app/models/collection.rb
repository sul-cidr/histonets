class Collection < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many :images
  has_one :histogram, dependent: :destroy, as: :histogramable
  has_many :collection_templates, dependent: :destroy

  ##
  # Creates a "Composite Histogram" consisting of colors and summed value counts
  # for all of the images within a given Collection
  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  def create_composite_histogram
    current_histogram = Histogram.find_or_create_by!(
      histogramable_id: id,
      histogramable_type: self.class.name
    )
    parsed = {}
    images.each do |image|
      image.calculate_histogram_now if image.histogram.nil?
      # Merge the values together
      parsed = parsed.merge(image.reload.parsed_histogram) do |_k, v1, v2|
        v1.to_i + v2.to_i
      end
    end
    current_histogram.update(histogram: parsed.to_json)
    save_histogram_file
  end

  ##
  # Replace parens with brackets for properly formed json, then store the
  # histogram in a local file
  def save_histogram_file
    hist_json = histogram.histogram.tr('(', '[')
    hist_json = hist_json.tr(')', ']')
    File.write(histogram_file_name, hist_json)
  end

  def histogram_file_name
    "spec/fixtures/data/collection_#{id}_histogram.txt"
  end

  ##
  # Creates a palette based on the composite histogram, to be used in the
  # image clean process
  def create_palette
    CreatePaletteJob.perform_now(self)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
