# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "keydown"
  s.version     = Keydown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Davis W. Frank"]
  s.email       = ["dwfrank@infe.ws"]
  s.homepage    = "http://rubygems.org/gems/keydown"
  s.summary     = %q{Yet another "Slides in HTML" generator}
  s.description = %q{Bastard child of Slidedown, HTML5 Rocks, and organic fair trade Bolivian coffee}

  s.add_dependency 'thor', '>= 0.14.0'
  s.add_dependency 'rdiscount', '>= 1.6.8'
  s.add_dependency 'albino'

  s.add_development_dependency "rspec", ">= 2.5.0"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "gem-release"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
