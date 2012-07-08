require 'capistrano'
require 'capistrano/cli'

Dir[File.expand_path('../recipes/*.rb', __FILE__)].sort.each { |f| load f }