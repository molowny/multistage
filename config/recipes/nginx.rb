namespace :nginx do

  desc 'Install latest stable release of nginx'
  task :install, roles: :web do
    run "#{sudo} add-apt-repository ppa:nginx/stable --yes"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after 'deploy:install', 'nginx:install'

  desc 'Setup nginx configuration for this application'
  task :setup, roles: :web do
    template 'nginx.conf', '/tmp/nginx.conf', true

    run "#{sudo} mv /tmp/nginx.conf /etc/nginx/sites-enabled/#{application}_#{stage}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"

    restart
  end
  after 'deploy:setup', 'nginx:setup'
  
  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end

end