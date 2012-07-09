begin
  Capistrano::Configuration.instance.load do
    namespace :imagemagick do
      desc "Installing ImageMagick"
      task :install, roles: :web do
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install libmagickwand-dev imagemagick"
      end
      after "debot:install", "imagemagick:install"
    end
  end
rescue
end
