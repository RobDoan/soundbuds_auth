set :stages, %w(staging production)
set :default_stage, "staging" #deploy seperate features
require "bundler/capistrano"
require 'capistrano/ext/multistage'
load 'deploy/assets'

set :application, "soundbuds_auth"
set :repository, "git@github.com:RobDoan/soundbuds_auth.git"

set :scm, :git

set :deploy_to, "/home/deployer/#{application}"

set :deploy_via, :remote_cache

set :user, 'deployer'
set :use_sudo, false
default_run_options[:pty] = true

set :rake, "bundle exec rake"

set :default_environment, {'PATH' => "/opt/rbenv/bin:/usr/local/bin/:$PATH"}

after 'deploy:update_code', 'bundle:install'
before 'deploy:assets:precompile', 'config:symlink'
after :deploy, 'deploy:send_notification'


namespace :deploy do

  task :start do
    ;
  end

  task :stop do
    ;
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

namespace :config do
  desc "links all configuration file form config folder of share to config"
  task :symlink do
    run "ln -nfs #{shared_path}/config/*  #{release_path}/config/ ; ln -nfs #{shared_path}/initializers/*  #{release_path}/config/initializers/ "
  end

  desc "Link database.yml to config folder"
  task :symlink_database do
    run "ln -nfs #{shared_path}/database.yml  #{release_path}/config/"
  end

end

require './config/boot'
