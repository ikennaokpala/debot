# -*- encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require "debot/version"

Gem::Specification.new do |gem|
  gem.platform = Gem::Platform::RUBY
  gem.authors       = ["Ikenna Okpala"]
  gem.email         = ["ikennaokpala@gmail.com"]
  gem.description   = %q{Custom recipes that extend capisttrno for provisioning and deploying rails application to a VPS..}
  gem.summary       = %q{Home made capistrano recipes bundle into a gem..}
  gem.homepage      = "http://github.com/kengimel/debot"

  gem.required_rubygems_version = ">= 0.0.1.alpha"
  gem.rubyforge_project = "debot"


  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "debot"
  gem.require_paths = ["lib"]
  gem.version       = Debot::VERSION
  gem.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]

  gem.add_dependency "capistrano", ">= 2.12.0"
  gem.add_dependency "capistrano-ext", ">= 1.2.1"
end
