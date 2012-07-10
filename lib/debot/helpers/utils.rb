def template(from, to)
  require 'erb'
  erb = File.read(File.expand_path("../../../../generators/templates/#{from}", __FILE__))
  File.open(to, 'w') { |f| f.write(ERB.new(erb).result(binding)) } 
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end
