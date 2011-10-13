require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Keydown::HtmlHelpers do

  before do

    class TestContext
      include Keydown::HtmlHelpers
    end

    @context = TestContext.new
  end

  describe "#stylesheet" do
    it "should produce an HTML stylesheet link tag" do
      @context.stylesheet("/foo/bar/baz.css").should == %q{<link href="/foo/bar/baz.css" rel="stylesheet" type="text/css"/>}
    end
  end

  describe "#script" do
    it "should produce an HTML JavaScript script tag" do
      @context.script("/foo/bar/baz.js").should == %q{<script src="/foo/bar/baz.js" type="text/javascript"></script>}
    end
  end

end