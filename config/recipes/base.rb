def template(from, to, with_env = false)
  from = "#{from}.#{stage}" if with_env
  tpl = File.read(File.expand_path("../templates/#{from}.erb", __FILE__))
  put ERB.new(tpl).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

namespace :deploy do
  desc 'Setup base server instance'
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install curl git-core python-software-properties build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev libcurl4-openssl-dev"
  end
end