require 'capistrano'
require 'capistrano/cli'

Dir[File.join(File.dirname(__FILE__), '/recipes/*.rb')].sort.each { |f| load f }