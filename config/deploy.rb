set :application, 'histonets'
set :repo_url, 'https://github.com/sul-cidr/histonets.git'
set :user, 'histonets'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :home_directory, "/opt/app/#{fetch(:user)}"
set :deploy_to, "#{fetch(:home_directory)}/#{fetch(:application)}"

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{config/targets config/settings log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for keep_releases is 5
set :keep_releases, 5

# all servers (even -dev) will be rails_env production
set :rails_env, 'production'
