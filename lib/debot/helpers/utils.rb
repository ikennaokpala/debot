require 'erb'

def template_rake(from, to)
  File.open(to, 'w') { |f| f.write(ERB.new(erb_path(from)).result(binding)) } 
end

def template(from, to)
  put ERB.new(erb_path(from)).result(binding), to
end

def erb_path(from)
  File.read(File.expand_path("../../../../generators/templates/#{from}", __FILE__))
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

require 'rails'

module Setup
  def self.ask(question)
    process(question)
  end

  def self.ask?(question)
    %w[yes y yeah yep true].include?(process(question))
  end

  def self.run
    puts "Kindly provide the following details:"
    puts 
    @server = ask("Your server name or IP address:")
    @application_name = ask("Your application name:")
    @user = ask("Your deployment user's name:")
    @group = ask("Our deployment user's system group ?")
    @number_of_releases = ask("How many releases would like to keep?")
    @scm = ask("Your choosen scm (git or svn)?")
    @repository = ask("Enter your repository's url/location:")

    begin
      puts "Provide details for creating a multi-stage file:"
      puts
      @stage_name = ask("What would you like to call this stage file?")
      @domain = ask("What is your #{@stage_name} domain name?")
      @app_parent_directory = ask("What is the parent directory for #{@stage_name} stage? (Given full path details)")
      @deploy_to = ask("Where on your server would #{@stage_name} be located? (Give file path)")
      @branch = ask("What branch would you like to deploy for this stage?")
      stages_directory = File.join(Rails.root, "config/deploy")

      puts "Creating stage file #{stages_directory}/#{stage_name}.rb"

      if File.directory?(stages_directory)
        template_rake("stages.rb.erb", "#{stages_directory}/#{stage_name}.rb")
      else 
        system "mkdir -p #{stages_directory}"
        template_rake("stages.rb.erb", "#{stages_directory}/#{stage_name}.rb")
      end
    end while(ask?("Would you like to create a (another) stage file? (yes/no)"))

    deploy_directory = File.join(Rails.root, "config")

    puts "Creating your deploy file #{deploy_directory}/deploy.rb"

    template_rake("deploy.rb.erb", "#{deploy_directory}/deploy.rb")

  end

  private
  def self.process(question)
    puts question
    STDIN.gets.chomp.downcase #returns user input
  end
end
