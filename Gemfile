source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.0'
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'react-rails'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'config'

gem 'riiif', '>= 1.4.3'

gem 'wicked' # For step by step form creation

gem 'bootstrap', '>= 4.0.0.alpha6', '< 5'

gem 'iiif-presentation'

gem 'honeybadger', '~> 3.1'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0' # Required for tooltips/popover for twbs
  gem 'rails-assets-leaflet-iiif', '~> 1.0'
  gem 'rails-assets-leaflet', '~> 1.0'
  gem 'rails-assets-css-toggle-switch'
end

gem 'sidekiq'

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.6'
  gem 'codecov', :require => false
  gem 'teaspoon-jasmine'
  gem 'poltergeist'
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-sidekiq'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'rb-fsevent', '0.9.8' # See issue https://github.com/guard/listen/issues/431
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :deployment do
  gem 'dlss-capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem 'capistrano-sidekiq'
end
