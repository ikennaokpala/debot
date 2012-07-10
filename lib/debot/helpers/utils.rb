def template(from, to)
  require 'erb'
  erb = File.read(File.expand_path("../../../../generators/templates/#{from}", __FILE__))
  File.open(to, 'w') { |f| f.write(ERB.new(erb).result(binding)) } 
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

module Setup
  def self.ask(question)
    process(question)
  end

  def self.ask?(question)
    %w[yes y yeah yep true].include?(process(question))
  end

  def self.run
    puts "Kindly provide the following details:"
    @server = ask("Your server name or IP address:")
    @application_name = ask("Your application name:")
    @user = ask("Your deployment user's name:")
    @group = ask("Our deployment user's system group ?")
    @number_of_releases = ask("How many releases would like to keep?")
    @scm = ask("Your choosen scm (git or svn)?")
    @repository = ask("Enter your repository's url/location:")
    @stage_names = []
    @domain = ""
    @branch = ""

    begin
      puts "Provide details for creating a multi-stage file:"
      @stage_name = ask("What would you like to call this stage file?")
      @stage_names << @stage_name
      @domain = ask("What is your domain name?")
      @deploy_to = ask("Where on your server would this file be located? (Give file path)")
      @branch = ask("What branch would you like to deploy for this stage?")
    end while(ask?("Would you like to create a (another) stage file? (yes/no)"))

    deploy_directory = File.join(Rails.root, "config")

    @stage_names.each do |stage_name|
      stages_directory = File.join(Rails.root, "config/deploy")

      puts "Creating stage file #{stages_directory}/#{stage_name}.rb"

      if File.directory?(stages_directory)
        template("stages.rb.erb", "#{stages_directory}/#{stage_name}.rb")
      else 
        system "mkdir -p #{stages_directory}"
        template("stages.rb.erb", "#{stages_directory}/#{stage_name}.rb")
      end
    end

    puts "Creating your deploy file #{deploy_directory}/deploy.rb"

    template("deploy.rb.erb", "#{deploy_directory}/deploy.rb")

  end

private
  def self.process(question)
    puts question
    STDIN.gets.chomp.downcase #returns user input
  end
end
