namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :setup, roles: :app do
    run "cd #{current_path}; bundle exec foreman export upstart /tmp/upstart -a #{application}_#{stage} -u #{user} -l #{shared_path}/log"
    run "#{sudo} cp /tmp/upstart/* /etc/init"
  end
  # after 'deploy:setup', 'foreman:setup'
  after 'deploy:update', 'foreman:setup'

  desc 'Start the application services'
  task :start, roles: :app do
    run "#{sudo} start #{application}_#{stage}"
  end
  after 'deploy:start', 'foreman:start'

  desc 'Stop the application services'
  task :stop, roles: :app do
    run "#{sudo} stop #{application}_#{stage}"
  end
  after 'deploy:stop', 'foreman:stop'

  desc 'Restart the application services'
  task :restart, roles: :app do
    run "#{sudo} restart #{application}"
    run "#{sudo} start #{application}_#{stage} || #{sudo} restart #{application}_#{stage}"
  end
  after 'deploy:restart', 'foreman:restart'
end