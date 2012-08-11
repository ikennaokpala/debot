#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "default_task"
  t.test_files = [] #FileList['path/to/*.rb']
  t.verbose = false#true
end

task :default => :test
