class Image < ApplicationRecord
  has_and_belongs_to_many :collections
  has_many :collection_templates
  has_one :histogram, dependent: :destroy
  validates :file_name, uniqueness: true

  def file_name_no_extension
    File.basename(file_name, extension)
  end

  def extension
    File.extname(file_name)
  end

  def self.from_file_path(path)
    Image.find_or_create_by!(file_name: File.basename(path))
  end
end
