$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'keydown'
require 'rspec'
require 'pp'

require 'nokogiri'
require 'tmpdir'

def capture_output
   output = StringIO.new
   $stdout = output
   yield
   output.string
 ensure
   $stdout = STDOUT
end
