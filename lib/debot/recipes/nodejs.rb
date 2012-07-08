 Capistrano::Configuration.instance.load do
  namespace :nodejs do
    desc "Install the latest relase of Node.js"
    task :install, roles: :app do
      run "#{sudo} add-apt-repository -y ppa:chris-lea/node.js"
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install nodejs"
    end
    after "debot:install", "nodejs:install"
  end
end