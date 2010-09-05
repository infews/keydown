require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SlideDeck" do

  describe "with a title" do
    before :each do
      @slides_text = <<-SLIDE
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
      @deck        = SlideDeck.new(@slides_text)
    end

    describe "when extracting slides" do

      it "should find the document's title" do
        @deck.title.should == "Kermit the Frog Says..."
      end

      it "should find all the slides in the markdown" do
        @deck.slides.length.should == 3
      end
    end

    describe "when generating HTML" do
      before :each do
        @html = @deck.to_html
        @doc = Nokogiri(@html)
      end

      it "should set the document's title" do
        @doc.css('title').text.should == "Kermit the Frog Says..."
      end

      it "should generate the correct number of slides" do
        @doc.css('div.slide').length.should == 3
      end

      it "should set the CSS classnames of each slide"

    end
  end

end
