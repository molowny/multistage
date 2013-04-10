namespace :libs do

  namespace :postfix do
    desc 'Install the latest stable release of postfix.'
    task :install, roles: :app do
      run "#{sudo} apt-get -y install postfix"
    end
    after 'deploy:install', 'libs:postfix:install'
  end

  namespace :imagemagick do
    desc 'Install the latest stable release of imagemagick.'
    task :install, roles: :app do
      run "#{sudo} apt-get -y install imagemagick"
    end
    after 'deploy:install', 'libs:imagemagick:install'
  end

  namespace :nodejs do
    desc 'Install the latest stable release of nodeJs.'
    task :install, roles: :app do
      run "#{sudo} add-apt-repository ppa:chris-lea/node.js --yes"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nodejs"
    end
    after 'deploy:install', 'libs:nodejs:install'
  end

end
