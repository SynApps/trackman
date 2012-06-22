# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trackman/version"

Gem::Specification.new do |s|
  s.name        = "trackman"
  s.version     = Trackman::VERSION
  s.authors     = ["Jeremy Fabre", "Emanuel Petre"]
  s.email       = ["jeremy.fabre@hotmail.com", "petreemanuel@gmail.com"]
  s.homepage    = "https://github.com/SynApps/trackman"
  s.summary     = "Client version of the Trackman addon on Heroku"
  s.description = "Trackman hosts your maintenances and app-down pages (503s) and lets you keep them in your current development environment so that you can focus on delivering and not configuring."

  #s.rubyforge_project = "trackman"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "rack"
  s.add_runtime_dependency "heroku", ">= 2.26.2"
  
  s.add_development_dependency "rspec"
end
