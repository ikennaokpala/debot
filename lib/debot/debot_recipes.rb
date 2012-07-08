require 'capistrano'
require 'capistrano/cli'

Dir[File.expand_path('../recipes/base.rb', __FILE__)].sort.each { |f| load f }