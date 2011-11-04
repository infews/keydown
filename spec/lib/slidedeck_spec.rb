require 'spec_helper'

describe Keydown::SlideDeck do

  shared_examples_for "finding slides" do
    describe "when building slides" do

      it "should find the document's title" do
        @deck.title.should == "Kermit the Frog Says..."
      end

      it "should find all the slides in the markdown" do
        @deck.slides.length.should == 3
      end
    end
  end

  before :each do
    module Keydown
      class Tasks
        def self.template_dir
          File.join(Keydown::Tasks.source_root, 'templates', 'deck.js')
        end
      end
    end
  end

  describe "with a title" do
    before :each do
      @slides_text = <<-SLIDES
# Kermit the Frog Says...

!SLIDE

# This Presentation

!NOTE

I think this should be ignored

!SLIDE foo

# Is Brought to You By

!NOTE

and this

!SLIDE foo bar

# The Letter Q

      SLIDES

      @deck = Keydown::SlideDeck.new(@slides_text)
    end

    it_should_behave_like "finding slides"

    describe "when generating HTML" do
      before :each do
        @html = @deck.to_html
        @doc = Nokogiri(@html)
      end

      it "should set the document's title" do
        @doc.css('title').text.should == "Kermit the Frog Says..."
      end

      it "should generate the correct number of slides" do
        @doc.css('section.slide').length.should == 3
      end

      it "should set the CSS classnames of each slide" do
        slides = @doc.css('.slide')

        first_slide = slides[0]
        first_slide['class'].should == 'slide'

        second_slide = slides[1]
        second_slide['class'].should == 'foo slide'

        third_slide = slides[2]
        third_slide['class'].should == 'bar foo slide'
      end
    end
  end

  describe "with a background image" do
    before :each do
      @slides_text = <<-SLIDES
# Kermit the Frog Says...

!SLIDE

# This Presentation

}}} images/my_background.png

!SLIDE foo

# Is Brought to You By

}}} images/ping.png::cprsize

!NOTE

and this

!SLIDE foo bar

# The Letter Q

}}} images/poke.png::cprsize::flickr::http://flickr.com/1234

      SLIDES

      @deck = Keydown::SlideDeck.new(@slides_text)
    end

    it_should_behave_like "finding slides"

    describe "when generating HTML" do
      before(:each) do
        @html = @deck.to_html
        @doc = Nokogiri(@html)
        @first_slide = @doc.css('section.slide')[0]
        @second_slide = @doc.css('section.slide')[1]
        @third_slide = @doc.css('section.slide')[2]
      end

      it "should add the full-bleed background CSS classname to any slide that specifies a background" do
        @first_slide['class'].split(' ').should include('full-background')
        @second_slide['class'].split(' ').should include('full-background')
        @third_slide['class'].split(' ').should include('full-background')
      end

      it "should add a custom classname to a slide that specifies a background" do
        @first_slide['class'].split(' ').should include('my_background')
        @second_slide['class'].split(' ').should include('ping')
        @third_slide['class'].split(' ').should include('poke')
      end

      it "should add an attribution element only to slides that requested it" do
        @first_slide.css('.attribution').length.should == 0
        @second_slide.css('.attribution').length.should == 1
        @third_slide.css('.attribution').length.should == 1
      end

      it "should add attribution content to slides that requested it" do
        @second_slide.css('a')[0].text.should match('cprsize')
        @third_slide.css('a')[0].text.should match('cprsize')
      end

      it "should add an attribution link if provided" do
        @second_slide.css('a')[0]['href'].should be_nil
        @third_slide.css('a')[0]['href'].should match(/^http:/)
      end
    end
  end
end