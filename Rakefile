$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "bunchball/version"

task :build do
  system "gem build bunchball.gemspec"
end

task :release => :build do
  system "gem push bunchball-#{Bunchball::VERSION}"
end
