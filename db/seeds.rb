# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dir.chdir(Rails.root.join('data'))
collections = Dir.glob('*').select { |fn| File.directory?(fn) }
collections.each do |folder|
  collection = Collection.find_or_create_by!(name: folder)
  image_files = File.join(folder, "*.{jpg,tif,tiff,png}")
  images = Dir.glob(image_files)
  images.each do |image_path|
    puts image_path
    puts '------'
    image = Image.from_file_path(image_path)
    filenames = collection.images.map(&:file_name)
    collection.images.push(image) if not filenames.include? image.file_name
  end
  collection.save!
end
