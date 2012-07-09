namespace :debot do
  desc "Setup deploy.rb file and stages"
  task :setup do
    Ask.run
  end
end

module Ask
  def self.ask(question)
    process(question)
  end

  def self.ask?(question)
    %w[yes y yeah yep true].include?(process(question))
  end

  def self.run
    puts "Kindly provide the following details:"
    server = ask("Your server name or IP address:")
    application_name = ask("Your application name:")
    user = ask("Your deployment user's name:")
    group = ask("Our deployment user's system group ?")
    number_of_releases = ask("How many releases would like to keep?")
    scm = ask("Your choosen scm (git or svn)?")
    repo = ask("Enter your repository's url/location:")
    stage_names = []
    begin
      stage_name = ask("What is the  ")
      stage_names << stage_name
      domain = ask("What is your domain name?")
      branch = ask("What branch would your like to deploy for this stage?")
   end while(ask?("Would you like to create a (another) stage file?"))
  end

private
  def self.process(question)
    puts question
    STDIN.gets.chomp.downcase #returns user input
  end
end
