require 'spec_helper'

describe Keydown::Classnames do

  describe "#add" do
    before do
      @classnames = Keydown::Classnames.new
      @classnames.add("foo")
      @classnames.add("bar baz")
    end

    it "should return an empty hash" do
      @classnames.as_hash.should == {:class => "foo bar baz"}
    end

    it "should not duplicate classnames" do
      @classnames.add("foo")
      @classnames.as_hash.should == {:class => "foo bar baz"}
    end
  end


  describe "#as_hash" do
    describe "with no classnames" do
      before do
        @classnames = Keydown::Classnames.new
      end

      it "should return an empty hash" do
        @classnames.as_hash.should == {}
      end
    end

    describe "with classnames" do
      before do
        @classnames = Keydown::Classnames.new("foo bar baz")
      end

      it "should return a hash of classnames for use in HAML" do
        @classnames.as_hash.should == {:class => "foo bar baz"}
      end
    end
  end
end