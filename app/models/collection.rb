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
      image.calculate_histogram_now if image.histogram.blank?
      # Merge the values together
      parsed = parsed.merge(image.reload.parsed_histogram) do |_k, v1, v2|
        v1.to_i + v2.to_i
      end
    end
    current_histogram.update(histogram: parsed.to_json)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
