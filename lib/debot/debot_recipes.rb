require 'capistrano'
require 'capistrano/cli'

Capistrano::Configuration::Namespaces::Namespace.class_eval do
  def capture(*args)
    parent.capture *args
  end
end #this is a work around for issue 168 https://github.com/capistrano/capistrano/issues/168#issuecomment-4144687

Dir[File.expand_path('../recipes/*.rb', __FILE__)].sort.each { |f| load f }
