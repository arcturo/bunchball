# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'bunchball'

Gem::Specification.new do |s|
  s.name        = "bunchball"
  s.version     = Bunchball::VERSION
  s.authors     = ["Ryan Waldron"]
  s.email       = ["rew@arcturo.com"]
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
