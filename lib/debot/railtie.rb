require 'debot'
require 'rails'
module Debot
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../tasks/debot.rake",__FILE__)
    end
  end
end