require 'spec_helper'

describe Keydown::Slide do
  before :each do
    module Keydown
      class Tasks
        def self.template_dir
          File.join(Keydown::Tasks.source_root, 'templates', 'deck.js')
        end
      end
    end
  end

  shared_examples_for 'extracting slide data' do

    it "should set the CSS classnames" do
      @slide.classnames.to_s.should == @classnames
    end

    it "should extract the slide content" do
      @slide.content.should match(/^# A Slide/)
      @slide.content.should match(/With some text/)
    end

    it "should remove the notes from the content" do
      @slide.content.should_not match(/a simple note/)
    end

    it "should extract the notes" do
      @slide.notes.should match(/a simple note/)
    end
  end

  shared_examples_for "generating HTML" do
    it "should assign the classname(s) to the section" do
      @doc.css(@slide_selector).should_not be_nil
    end

    it "should convert the content via Markdown" do
      @doc.css('section h1').text.should == 'A Slide'
    end

    it "should not include the notes in the HTML" do
      @doc.css('section p').each do |node|
        node.text.should_not match(/!NOTES/)
      end
    end
  end

  shared_examples_for "syntax highlighting" do
    it "setup the code segments for highlighting" do
      @doc.css('textarea').length.should == 1

      code_block = @doc.css('textarea')[0]
      code_block['class'].should == 'code'
      code_block['mode'].should == 'ruby'
    end
  end

  describe 'without a CSS classname' do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = 'slide'
      @slide = Keydown::Slide.new(@slide_text)
    end

    it_should_behave_like "extracting slide data"

    describe "when generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section"
      end

      it_should_behave_like "generating HTML"
    end
  end

  describe "with a single CSS classname" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = ['foo', 'slide'].sort.join(' ')
      @slide = Keydown::Slide.new(@slide_text, 'foo')
    end

    it_should_behave_like "extracting slide data"

    describe "when generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section.#{@classnames}"
      end

      it_should_behave_like "generating HTML"
    end
  end

  describe "with multiple CSS classnames" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = ['slide', 'foo', 'bar'].sort.join(' ')
      @slide = Keydown::Slide.new(@slide_text, 'foo bar')

    end

    it_should_behave_like "extracting slide data"

    describe "generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section.#{@classnames}"
      end
      it_should_behave_like "generating HTML"
    end
  end

 describe "with the classname of 'left'" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = ['slide', 'left', 'foo'].sort.join(' ')
      @slide = Keydown::Slide.new(@slide_text, 'foo left')

    end

    it_should_behave_like "extracting slide data"

    describe "generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section.#{@classnames}"
      end

      it_should_behave_like "generating HTML"

      it "should add the classname 'left' to the section (in order to justify the whole slide)" do
        @doc.css('section')[0]['class'].should include('left')
      end

    end
  end

  describe "without a note" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text
      SLIDE

      @classnames = 'slide'
      @slide = Keydown::Slide.new(@slide_text)
    end

    it "should set the CSS classnames" do
      @slide.classnames.to_s.should == @classnames
    end

    it "should extract the slide content" do
      @slide.content.should match(/^# A Slide/)
      @slide.content.should match(/With some text/)
    end

    describe "when generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section"
      end

      it_should_behave_like "generating HTML"
    end
  end

  describe "with code to higlight" do

    describe "using the Slidedown syntax" do
      before :each do
        @slide_text = <<-SLIDE

# A Slide
With some text

@@@ ruby
  def a_method(options)
    puts "I can has options " + options
  end
@@@
!NOTES
a simple note

        SLIDE

        @classnames = 'slide'
        template_dir = File.join(Keydown::Tasks.source_root, 'templates', 'deck.js')
        @slide = Keydown::Slide.new(@slide_text)
      end

      it_should_behave_like "extracting slide data"

      describe "when generating HTML" do
        before :each do
          @html = @slide.to_html
          @doc = Nokogiri(@html)
          @slide_selector = "section"
        end

        it_should_behave_like "generating HTML"

        it_should_behave_like "syntax highlighting"
      end
    end

    describe "using the Github markup syntax" do
      before :each do
        @slide_text = <<-SLIDE

# A Slide
With some text

``` ruby
  def a_method(options)
    puts "I can has options " + options
  end
```
!NOTES
a simple note

        SLIDE

        @classnames = 'slide'
        @slide = Keydown::Slide.new(@slide_text)
      end

      it_should_behave_like "extracting slide data"

      describe "when generating HTML" do
        before :each do
          @html = @slide.to_html
          @doc = Nokogiri(@html)
          @slide_selector = "section"
        end

        it_should_behave_like "generating HTML"
        it_should_behave_like "syntax highlighting"

        it "should not have a an attribution for the background image" do
          @doc.css('.attribution').length.should == 0
        end
      end
    end
  end

  describe "with an image for a full-bleed background without attribution" do
    before(:each) do
      @slide_text = <<-SLIDE

# A Slide
With some text

}}} images/my_background.png

!NOTES
a simple note

      SLIDE

      @classnames = 'full-background my_background slide'
      @slide = Keydown::Slide.new(@slide_text.chomp)
    end

    it_should_behave_like "extracting slide data"

    describe "when generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section"
        @slide_container = @doc.css('section.slide')[0]
      end

      it_should_behave_like "generating HTML"

      it "should remove any declaration of a background image" do
        @doc.css(@slide_selector)[0].content.should_not match(/\}\}\}\s+images\/my_background\.png/)
      end

      it "should save off the background image info for use when generating the HTML" do
        @slide.background_image.should == {:classname => 'my_background', :path => 'images/my_background.png'}
      end

      it "should add the full-background class to the containing div" do
        @slide_container['class'].split(' ').should include('full-background')
      end

      it "should add the background image class to the containing div" do
        @slide_container['class'].split(' ').should include('my_background')
      end

      it "should not have a an attribution for the background image" do
        @doc.css('.attribution').length.should == 0
      end

    end
  end

  describe "with an image for a full-bleed background with a Flickr attribution" do
    before(:each) do
      @slide_text = <<-SLIDE

# A Slide
With some text

}}} images/my_background.png::cprsize::flickr::http://flickr.com/1234

!NOTES
a simple note

      SLIDE

      @classnames = 'full-background my_background slide'
      @slide = Keydown::Slide.new(@slide_text.chomp)
    end

    it_should_behave_like "extracting slide data"

    describe "when generating HTML" do
      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
        @slide_selector = "section"
        @slide_container = @doc.css('section.slide')[0]
      end

      it_should_behave_like "generating HTML"

      it "should remove any declaration of a background image" do
        @doc.css(@slide_selector)[0].content.should_not match(/\}\}\}\s+images\/my_background\.png/)
      end

      it "should save off the background image info for use when generating the HTML" do
        @slide.background_image[:classname].should == 'my_background'
        @slide.background_image[:path].should == 'images/my_background.png'
        @slide.background_image[:service].should == 'flickr'
        @slide.background_image[:attribution_text].should == 'cprsize'
        @slide.background_image[:attribution_link].should == 'http://flickr.com/1234'
      end

      it "should add the full-background class to the containing div" do
        @slide_container['class'].split(' ').should include('full-background')
      end

      it "should add the background image class to the containing div" do
        @slide_container['class'].split(' ').should include('my_background')
      end

      describe "it makes an attribution element that" do
        before(:each) do
          @attribution = @doc.css('.attribution')[0]
        end

        it "should have the specified CSS class" do
          @attribution['class'].split(' ').should include('flickr')
        end

        it "should have the specified text" do
          @attribution.content.should match(/cprsize/)
        end

        it "should have the specified link" do
          @attribution.css('a')[0]['href'].should match('http://flickr.com/1234')
        end
      end
    end
  end
end
