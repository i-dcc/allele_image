# Add the lib directory to the search path

require 'bundler'
require 'bundler/setup'

Bundler::GemHelper.install_tasks

desc 'Default task: run all tests'
task :default => [:test]

# Load rake tasks from the tasks directory
Dir["#{File.dirname(__FILE__)}/tasks/*.task"].each { |t| load t }
