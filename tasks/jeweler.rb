require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "keydown"
    gem.summary = %Q{Another HTML5 presentation generator}
    gem.description = %Q{Another HTML5 presentation generator}
    gem.email = "dwfrank+github@infe.ws"
    gem.homepage = "http://github.com/infews/keydown"
    gem.authors = ["Davis W. Frank"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "nokogiri", ">= 1.4.3.1"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
