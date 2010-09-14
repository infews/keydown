require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Keydown::SlideDeck do
  before :each do
    class Keydown
      def self.template_dir
        File.join(Keydown.source_root, 'templates', 'rocks')
      end
    end
  end

  describe "with a title" do
    before :each do
      @slides_text      = <<-SLIDE
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

      SLIDE

      @deck             = Keydown::SlideDeck.new(@slides_text)
    end

    describe "when building slides" do

      it "should find the document's title" do
        @deck.title.should == "Kermit the Frog Says..."
      end

      it "should find all the slides in the markdown" do
        @deck.slides.length.should == 3
      end
    end

    describe "when generating HTML" do
      before :each do
        @html    = @deck.to_html
        @doc     = Nokogiri(@html)
      end

      it "should set the document's title" do
        @doc.css('title').text.should == "Kermit the Frog Says..."
      end

      it "should generate the correct number of slides" do
        @doc.css('div.slide').length.should == 3
      end

      it "should set the CSS classnames of each slide" do
        slides = @doc.css('div.slide')

        slides[0]['class'].should == 'slide'
        slides[1]['class'].should == 'slide foo'
        slides[2]['class'].should == 'slide foo bar'
      end
    end
  end
end
