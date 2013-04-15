require 'keydown'
require 'nokogiri'

require 'tmpdir'
require 'pp'

def capture_output
   output = StringIO.new
   $stdout = output
   yield
   output.string
 ensure
   $stdout = STDOUT
end

RSpec.configure do |config|
  config.before(:each) do
    Launchy.stub(:open)
  end
end
