begin
  Capistrano::Configuration.instance.load do
    set_default :ruby_version, "1.9.3-p286"
    #set_default :rbenv_bootstrap, "bootstrap-ubuntu-11-10"

    namespace :rbenv do
      desc "Install rbenv, Ruby, and the Bundler gem"
      task :install, roles: :app do
        run "#{sudo} apt-get -y install curl git-core"
        run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
        bashrc = <<-BASHRC
    if [ -d $HOME/.rbenv ]; then
      export PATH="$HOME/.rbenv/bin:$PATH"
      eval "$(rbenv init -)"
    fi
    BASHRC
        put bashrc, "/tmp/rbenvrc"
        run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
        run "mv ~/.bashrc.tmp ~/.bashrc"
        run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
        run %q{eval "$(rbenv init -)"}
        #run "rbenv #{rbenv_bootstrap}" # the next two lines are workarounds from .rbenv/plugins/rbenv-installer/bin/rbenv-bootstrap-ubuntu-11-10
        run "#{sudo} apt-get -y update"
        run "#{sudo} apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev"
        run "rbenv install #{ruby_version}"
        run "rbenv global #{ruby_version}"
        run "gem install bundler --no-ri --no-rdoc"
        run "rbenv rehash"
      end
      after "debot:install", "rbenv:install"
    end
  end
rescue
end