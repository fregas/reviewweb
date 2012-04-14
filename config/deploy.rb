require 'capistrano/ext/multistage'

set :stages, %w(production)
#set :default_stage, "production"

set :use_sudo, false


set :application, 'reviewsomewebsites.com'

set :repository, "http://s1.mediaartisans.com:8080/svn/reviewsomewebsites/trunk/"


set :scm, :subversion
set :scm_verbose, true
set :svn_username, 'fregas'
set :svn_password, 'unferth1!'
set :synchronous_connect, true

default_run_options[:pty] = true




namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy", "deploy:cleanup"
after "deploy:migrate", "deploy:cleanup"

