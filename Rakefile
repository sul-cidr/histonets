# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

# This task creates the composite histograms and palettes for all collections
# It should be run after rails db:seed
# To run: bundle exec rake histogram
# Before running, make sure all image files are in spec/fixtures/images
task :histogram => :environment do
  collections = Collection.all
  puts collections
  collections.each do |collection|
    puts "creating composite histogram for #{collection.name}"
    collection.create_composite_histogram
    puts "creating palette for #{collection.name}"
    collection.create_palette
  end
end
