# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bunchball/version'

Gem::Specification.new do |s|
  s.name        = "bunchball"
  s.version     = Bunchball::VERSION
  s.authors     = ["Arcturo"]
  s.email       = ["info@arcturo.com"]
  s.homepage    = "http://arcturo.com"
  s.summary     = %q{Wrapper for the Bunchball.com API}
  s.description = %q{The gem provides a fairly thin wrapper around connections to the Bunchball gamification API.}

  s.rubyforge_project = "bunchball"

  s.add_dependency 'httparty'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
