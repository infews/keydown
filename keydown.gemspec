# -*- encoding: utf-8 -*-
$:.push File.expand_path('lib', __FILE__)
require './lib/version.rb'

Gem::Specification.new do |s|
  s.name        = "keydown"
  s.version     = Keydown::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Davis W. Frank"]
  s.email       = ["dwfrank@infe.ws"]
  s.homepage    = "http://rubygems.org/gems/keydown"
  s.summary     = %q{Yet another "Slides in HTML" generator}
  s.description = %q{Bastard child of Slidedown, deck.js and organic fair trade Bolivian coffee}

  s.add_dependency 'thor'
  s.add_dependency 'tilt'
  s.add_dependency 'haml'
  s.add_dependency 'sass'
  s.add_dependency 'compass'
  s.add_dependency 'github-markdown'
  s.add_dependency 'launchy'

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "nokogiri"
  s.add_development_dependency "gem-release"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
