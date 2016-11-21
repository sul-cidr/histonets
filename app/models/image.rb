class Image < ApplicationRecord
  has_and_belongs_to_many :collections
  validates :file_name, uniqueness: true
end
