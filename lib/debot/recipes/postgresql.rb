begin
  Capistrano::Configuration.instance.load do
    set_default(:postgresql_host, "localhost")
    set_default(:postgresql_user) { stage_db_user }
    set_default(:postgresql_password) { Capistrano::CLI.password_prompt "PostgreSQL Password: " }
    set_default(:postgresql_database) { "#{application}_#{stage}" }
    set_default(:postgresql_dump_path) { "#{current_path}/tmp" }
    set_default(:postgresql_dump_file) { "#{application}_dump.sql" }
    set_default(:postgresql_local_dump_path) { "#{Bundler.root}/tmp" }

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

      namespace :local do
        desc "Dump local database only"
        task :dump do
          info  = YAML.load_file "#{Bundler.root}/config/database.yml"
          db    = info["development"]
          user, database = db['username'], db['database']
          commands = "pg_dump -U #{user} -h localhost #{database} | gzip > #{postgresql_local_dump_path}/#{postgresql_dump_file}.gz"
          system commands
        end
        desc "Download remote database to tmp/"
        task :download do
          dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}.gz"
          get "#{postgresql_dump_path}/#{postgresql_dump_file}.gz", dumpfile
        end

        desc "Restores local database from temp file"
        task :restore do
          auth = YAML.load_file "#{Bundler.root}/config/database.yml"
          dev  = auth['development']
          user, pass, database = dev['username'], dev['password'], dev['database']
          dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}"
          system "gzip -cd #{dumpfile}.gz > #{dumpfile} && cat #{dumpfile} | psql -U #{user} -h localhost #{database}"
        end

        desc "Dump remote database and download it locally"
        task :localize do
          remote.dump
          download
        end

        desc "Dump remote database, download it locally and restore local database"
        task :sync do
          localize
          restore
        end
      end

      namespace :remote do
        desc "Dump remote database"
        task :dump do
          dbyml = capture "cat #{shared_path}/config/database.yml"
          info  = YAML.load dbyml
          db    = info[stage.to_s]
          user, pass, database = db['username'], db['password'], db['database']
          commands = <<-CMD
            pg_dump -U #{user} -h localhost #{database} | \
            gzip > #{postgresql_dump_path}/#{postgresql_dump_file}.gz
          CMD
          run commands do |channel, stream, data|
            if data =~ /Password/
              channel.send_data("#{pass}\n")
            end
          end
        end

        desc "Uploads local sql.gz file to remote server"
        task :upload do
          dumpfile = "#{postgresql_local_dump_path}/#{postgresql_dump_file}.gz"
          upfile   = "#{postgresql_dump_path}/#{postgresql_dump_file}.gz"
          put File.read(dumpfile), upfile
        end

        desc "Restores remote database"
        task :restore do
          dumpfile = "#{postgresql_dump_path}/#{postgresql_dump_file}"
          gzfile   = "#{dumpfile}.gz"
          dbyml    = capture "cat #{shared_path}/config/database.yml"
          info     = YAML.load dbyml
          db       = info[stage.to_s]
          user, pass, database = db['username'], db['password'], db['database']

          commands = <<-CMD
            gzip -cd #{gzfile} > #{dumpfile} && \
            psql -d #{database} -U #{user} -h localhost -f #{dumpfile}
          CMD

          run commands do |channel, stream, data|
            if data =~ /Password/
              channel.send_data("#{pass}\n")
            end
          end
        end

        desc "Uploads and restores remote database"
        task :sync do
          upload
          restore
        end
      end
    end
  end
rescue
end
