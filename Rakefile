$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bunchball/version"

task :build do
  system "gem build bunchball.gemspec"
end

task :release => :build do
  system "gem push bunchball-#{Bunchball::VERSION}"
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/test_*.rb'
end

namespace :test do
  Rake::TestTask.new(:lint) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/test_active_model_lint.rb'
  end

  task :all => ['test']
end

task :default => 'test:all'

