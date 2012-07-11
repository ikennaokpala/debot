 begin
  Capistrano::Configuration.instance.load do
    namespace :nginx do
      desc "Install latest stable release of nginx"
      task :install, roles: :web do
        run "#{sudo} add-apt-repository -y ppa:nginx/stable"
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install nginx"
      end
      after "debot:install", "nginx:install"

      desc "Setup nginx configuration for this application"
      task :setup, roles: :web do
        run "mkdir -p #{shared_path}/nginx"
        template "nginx_unicorn.erb", "#{shared_path}/nginx/nginx_conf"
        run "#{sudo} mv #{shared_path}/nginx/nginx_conf /etc/nginx/sites-enabled/#{domain}"
        #run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
        restart
      end
      after "deploy:setup", "nginx:setup"

      %w[start stop restart].each do |command|
        desc "#{command} nginx"
        task command, roles: :web do
          run "#{sudo} service nginx #{command}"
        end
      end
    end
  end
rescue
end
