# server uses standardized suffix
server 'cidr-histonets-dev.stanford.edu', user: 'histonets', roles: %w{web db app}
set :bundle_without, %w(test deployment development).join(' ')

# sidekiq processes
set :sidekiq_processes, 1
set :sidekiq_concurrency, 2

Capistrano::OneTimeKey.generate_one_time_key!
