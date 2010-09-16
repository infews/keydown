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
      @slides_text      = <<-SLIDES
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
        slides = @doc.css('div.slide section')

        slides[0]['class'].should == nil
        slides[1]['class'].should == 'foo'
        slides[2]['class'].should == 'foo bar'
      end
    end
  end

  describe "with a background image" do
    before :each do
      @slides_text      = <<-SLIDES
# Kermit the Frog Says...

!SLIDE

# This Presentation

}}} images/my_background.png

!SLIDE foo

# Is Brought to You By

!NOTE

and this
     SLIDES

      @deck             = Keydown::SlideDeck.new(@slides_text)
    end

    describe "when generating HTML" do
      before(:each) do
        @html    = @deck.to_html
        @doc     = Nokogiri(@html)
        @slide_with_background = @doc.css('div.slide')[0]
      end

      it "should add the full-bleed background CSS classname to any slide that specifies a background" do
        @slide_with_background['class'].split(' ').should include('full-background')
      end

      it "should add a custom classname to a slide that specifies a background" do
        @slide_with_background['class'].split(' ').should include('my_background')
      end
    end


  end
end
