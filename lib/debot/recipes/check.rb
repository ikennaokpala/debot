Capistrano::Configuration.instance.load do
  namespace :check do
    desc "Make sure local git is in sync with remote."
    task :revision, roles: :web do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{branch}`
        puts "WARNING: HEAD is not the same as origin/#{branch}"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  #before "debot", "check:revision"
  #before "debot:migrations", "check:revision"
  #before "debot:cold", "check:revision"
  end
end
