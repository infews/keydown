$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'keydown'
require 'spec'
require 'spec/autorun'
require 'pp'

require 'nokogiri'
require 'tmpdir'

Spec::Runner.configure do |config|
  
end
