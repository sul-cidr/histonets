# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
image_files = Rails.root.join(Settings.IMAGE_PATH, '*.{jpg, tif, tiff, png}')

Dir.glob(image_files)
  .reject{ |f| f[/.*_tmp.*/] }
  .map { |path| Image.from_file_path(path) }
