class Image < ApplicationRecord
  has_and_belongs_to_many :collections
  has_many :collection_templates
  validates :file_name, uniqueness: true

  def self.from_file_path(path)
    Image.find_or_create_by!(file_name: File.basename(path))
  end
end
