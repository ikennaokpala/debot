begin
  Capistrano::Configuration.instance.load do
    set_default(:postgresql_host, "localhost")
    set_default(:postgresql_user) { stage_db_user }
    set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
    set_default(:postgresql_database) { "#{application}_#{stage}" }

    namespace :postgresql do
      desc "Install the latest stable release of PostgreSQL."
      task :install, roles: :db, only: {primary: true} do
        run "#{sudo} add-apt-repository -y ppa:pitti/postgresql"
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install postgresql libpq-dev postgresql-contrib"
      end
      after "debot:install", "postgresql:install"

      desc "Create a database for this application."
      task :create_database, roles: :db, only: {primary: true} do
        run %Q{#{sudo} -u postgres psql -c "create user #{postgresql_user} with password '#{postgresql_password}';"}
        # run %Q{#{sudo} -u postgres psql -c "alter user #{postgresql_user} with superuser;"}
        run %Q{#{sudo} -u postgres psql -c "create database #{postgresql_database} owner #{postgresql_user};"}
        run %Q{#{sudo} -u postgres psql -d "#{postgresql_database}" -c "create extension if not exists hstore;"}
      end
      after "deploy:setup", "postgresql:create_database"

      desc "Generate the database.yml configuration file."
      task :setup, roles: :app do
        run "mkdir -p #{shared_path}/config"
        template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
      end
      after "deploy:setup", "postgresql:setup"

      desc "Symlink the database.yml file into latest release"
      task :symlink, roles: :app do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      end
      after "deploy:finalize_update", "postgresql:symlink"
    end
  end
rescue
end
