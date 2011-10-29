require 'spec_helper'

describe Keydown::Classnames do

  describe "#add" do
    before do
      @classnames = Keydown::Classnames.new
      @classnames.add("foo")
      @classnames.add("bar baz")
    end

    it "should return an empty hash" do
      @classnames.to_hash.should == {:class => "bar baz foo"}
    end

    it "should not duplicate classnames" do
      @classnames.add("foo")
      @classnames.to_hash.should == {:class => "bar baz foo"}
    end
  end

  describe "#to_s" do
    describe "with no classnames" do
      before do
        @classnames = Keydown::Classnames.new
      end

      it "should return an empty hash" do
        @classnames.to_s.should == ''
      end
    end

    describe "with classnames" do
      before do
        @classnames = Keydown::Classnames.new("foo bar baz")
      end

      it "should return a hash of classnames for use in HAML" do
        @classnames.to_s.should == 'bar baz foo'
      end
    end
  end

  describe "#to_hash" do
    describe "with no classnames" do
      before do
        @classnames = Keydown::Classnames.new
      end

      it "should return an empty hash" do
        @classnames.to_hash.should == {}
      end
    end

    describe "with classnames" do
      before do
        @classnames = Keydown::Classnames.new("foo bar baz")
      end

      it "should return a hash of classnames for use in HAML" do
        @classnames.to_hash.should == {:class => "bar baz foo"}
      end
    end
  end
end