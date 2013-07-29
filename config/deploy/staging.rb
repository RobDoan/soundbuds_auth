set :branch, ENV['BRANCH'] || 'staging'
set :rails_env, "staging"
set :keep_releases, 5

role :web, "ec2-122-248-206-137.ap-southeast-1.compute.amazonaws.com"
role :app, "ec2-122-248-206-137.ap-southeast-1.compute.amazonaws.com"
role :db,  "ec2-122-248-206-137.ap-southeast-1.compute.amazonaws.com", :primary => true # Migrations