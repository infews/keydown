require 'thor'

Dir["#{File.dirname(__FILE__)}/keydown/*.rb"].each do |file|
  require file
end
