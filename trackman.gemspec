# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trackman/version"

Gem::Specification.new do |s|
  s.name        = "trackman"
  s.version     = Trackman::VERSION
  s.authors     = ["Jeremy Fabre", "Emanuel Petre"]
  s.email       = ["jeremy.fabre@hotmail.com", "epetre@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Client version of the Trackman addon on Heroku}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "trackman"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rest-client", ">= 1.6.7"
  s.add_runtime_dependency "json", ">= 1.6.5"
  s.add_runtime_dependency "nokogiri", ">= 1.5.0"
  s.add_runtime_dependency "rack", ">= 1.4.1"

  s.add_development_dependency "rspec"
end
