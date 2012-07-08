require_relative 'helpers'

Capistrano::Configuration.instance.load do
  namespace :deploy do
    desc "Install everything onto the server"
    task :install do
      run "#{sudo} apt-get -y update"
      run "#{sudo} apt-get -y install python-software-properties"
    end

    desc "Remove application from server"
    task :takedown do
      run "#{sudo} rm /etc/init.d/unicorn_#{domain}"
      run "#{sudo} rm /etc/nginx/sites-enabled/#{domain}"
      run "cd /home/debot/apps/#{domain}/ && #{sudo} rm -r *"
      run %Q{#{sudo} -u postgres psql -c "drop database #{postgresql_database};"}
      run %Q{#{sudo} -u postgres psql -c "drop role #{postgresql_user};"}
    end
    before "deploy:takedown","unicorn:stop"
    after "deploy:takedown", "nginx:restart"

  namespace :go do
    desc "Switch to shortly page and move routes file"
    task :down do
      run "mv #{current_path}/config/routes.rb #{current_path}/config/routes_down.rb"
      run "cp #{current_path}/config/recipes/templates/routes.rb #{current_path}/config/"
      run "mv #{current_path}/public/index_live.html #{current_path}/public/index.html"
    end
    after "go:down", "deploy:restart"

    desc "Switch to live content and re-instate routes file"
    task :live do
      #run "rm #{current_path}/config/routes.rb"
      run "mv #{current_path}/config/routes_down.rb #{current_path}/config/routes.rb"
      run "mv #{current_path}/public/index.html #{current_path}/public/index_live.html"
    end
    after "go:live", "deploy:restart"
  end
end