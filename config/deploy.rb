require 'bundler/capistrano'
require 'capistrano/ext/multistage'

load 'config/recipes/base'
load 'config/recipes/libs'
load 'config/recipes/nginx'
load 'config/recipes/postgresql'
load 'config/recipes/rbenv'
load 'config/recipes/unicorn'
load 'config/recipes/foreman'

set :stages, %w(production staging)
set :default_stage, 'staging'
set(:rails_env) { fetch(:stage) }

set :shared_children, shared_children + %w(public/uploads public/assets)

set :application, 'multistage'
set :user, 'multistage'
set :deploy_to, "/home/#{user}/app"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, 'git'
set :repository, "git@github.com:olownia/#{application}.git"

set :default_environment, { 'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH" }
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy', 'deploy:cleanup' # keep only the last 5 releases

# namespace :deploy do
#   task :setup_db, roles: :app do
#     run "mkdir -p #{shared_path}/config"
#     put File.read('config/database.example.yml'), "#{shared_path}/config/database.yml"
#   end
#   after 'deploy:setup', 'deploy:setup_db'

#   task :setup_configs, roles: :app do
#     run "#{sudo} ln -nfs #{current_path}/config/deploy/nginx.#{stage}.conf /etc/nginx/sites-enabled/#{application}_#{stage}"
#     run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
#   end
#   after 'deploy:update', 'deploy:setup_configs'

#   desc 'Make sure local git is in sync with remote.'
#   task :check_revision, roles: :web do
#     unless `git rev-parse HEAD` == `git rev-parse origin/master`
#       puts 'WARNING: HEAD is not the same as origin/master'
#       puts 'Run `git push` to sync changes.'
#       exit
#     end
#   end
#   before 'deploy', 'deploy:check_revision'
# end

# namespace :foreman do
#   desc "Export the Procfile to Ubuntu's upstart scripts"
#   task :export, roles: :app do
#     run "cd #{current_path}; bundle exec foreman export upstart /tmp/upstart -a #{application}_#{stage} -u #{user} -l #{shared_path}/log"
#     run "#{sudo} cp /tmp/upstart/* /etc/init"
#   end
#   after 'deploy:update', 'foreman:export'

#   desc 'Start the application services'
#   task :start, roles: :app do
#     run "#{sudo} start #{application}_#{stage}"
#   end

#   desc 'Stop the application services'
#   task :stop, roles: :app do
#     run "#{sudo} stop #{application}_#{stage}"
#   end

#   desc 'Restart the application services'
#   task :restart, roles: :app do
#     run "#{sudo} restart #{application}"
#     run "#{sudo} start #{application}_#{stage} || #{sudo} restart #{application}_#{stage}"
#   end
#   after 'deploy:update', 'foreman:restart'
# end