require_relative '../helpers/utils'

namespace :debot do
  desc "Setup deploy.rb file and stages"
  task :setup do
    Setup.run
  end
end
