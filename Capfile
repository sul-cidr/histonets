# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'dlss/capistrano'
require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'capistrano/rvm'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
