require "bundler/gem_tasks"
require "rake/testtask"
require "service_layer"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.pattern = "test/**/test*.rb"
end

task :default => :test

