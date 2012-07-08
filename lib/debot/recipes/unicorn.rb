Capistrano::Configuration.instance.load do
  set_default(:unicorn_user) { user }
  set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
  set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
  set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
  set_default(:unicorn_workers, 2)

  namespace :unicorn do
    desc "Setup Unicorn initializer and app configuration"
    task :setup, roles: :app do
      run "mkdir -p #{shared_path}/config"
      run "mkdir -p #{shared_path}/unicorn/tmp/sockets"
      template "unicorn.rb.erb", unicorn_config
      template "unicorn_init.erb", "#{shared_path}/unicorn/unicorn_init"
      run "chmod +x #{shared_path}/unicorn/unicorn_init"
      run "#{sudo} mv #{shared_path}/unicorn/unicorn_init /etc/init.d/unicorn_#{domain}"
      run "#{sudo} update-rc.d -f unicorn_#{domain} defaults"
    end
    after "deploy:setup", "unicorn:setup"

    %w[start stop restart].each do |command|
      desc "#{command} unicorn"
      task command, roles: :app do
        run "service unicorn_#{domain} #{command}"
      end
      after "deploy:#{command}", "unicorn:#{command}"
    end
  end
end
