require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Slide" do

  shared_examples_for 'extracting slide data' do

    it "should set the classname to empty" do
      @slide.classnames.should == @classnames
    end

    it "should extract the content" do
      @slide.content.should match(/^# A Slide/)
    end

    it "should extract the notes" do
      @slide.notes.should match(/a simple note/)
    end

  end

  shared_examples_for "when generating HTML" do
    describe "when generating HTML" do

      before :each do
        @html = @slide.to_html
        @doc = Nokogiri(@html)
      end

      it "should assign the classname(s) to the section" do
        @doc.css(@section_selector).should_not be_nil
      end

      it "should convert the content via Markdown" do
        @doc.css('section h1').text.should == 'A Slide'
      end

      it "should highlight any code fragments"
    end

  end

  describe 'without a name' do
    before :each do
      @slide_text       = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @slide            = Slide.new(@slide_text)
      @classnames       = ''
      @section_selector = "section"
    end

    it_should_behave_like "extracting slide data"
    it_should_behave_like "when generating HTML"
  end

  describe "with a single name" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = 'foo'
      @slide      = Slide.new(@slide_text, @classnames)
      @section_selector = "section.#{@classnames}"
    end

    it_should_behave_like "extracting slide data"
    it_should_behave_like "when generating HTML"
  end

  describe "with multiple names" do
    before :each do
      @slide_text = <<-SLIDE

# A Slide
With some text

!NOTES
a simple note
      SLIDE

      @classnames = 'foo bar'
      @slide      = Slide.new(@slide_text, @classnames)
      @section_selector = "section.#{@classnames}"
    end

    it_should_behave_like "extracting slide data"
    it_should_behave_like "when generating HTML"

  end

end