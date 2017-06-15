class Image < ApplicationRecord
  has_and_belongs_to_many :collections
  has_many :collection_templates
  has_one :histogram, dependent: :destroy, as: :histogramable
  validates :file_name, uniqueness: true

  after_commit :calculate_histogram, on: :create

  def file_name_no_extension
    File.basename(file_name, extension)
  end

  def extension
    File.extname(file_name)
  end

  def self.from_file_path(path)
    Image.find_or_create_by!(file_name: File.basename(path))
  end

  def thumbnail_image_path
    return "#{Settings.HOST_URL}"\
    "#{Riiif::Engine.routes.url_helpers.image_path(
      file_name_no_extension,
      size: '200,',
      format: Settings.DEFAULT_IMAGE_EXTENSION
    )}"
  end

  protected

  def calculate_histogram
    CalculateHistogramJob.perform_later(self)
  end
end
