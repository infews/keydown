require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Slide" do

  describe 'without a name' do
    before :each do
      @slide_text = <<SLIDE
# A Slide
With some text
!NOTES
a simple note
SLIDE
      @slide      = Slide.new(@slide_text)
    end

    it "should set the classname to empty" do
      @slide.classnames.should be_empty
    end

    it "should extract the content" do
      @slide.content.should match(/^# A Slide/)
    end

    it "should extract the notes" do
      @slide.notes.should match(/a simple note/)
    end

    describe "when generating HTML" do

      it "should assign the classname(s) to the section"

      it "should convert the content via Markdown"

      it "should highlight any code fragments"

    end

  end

  describe "with a single name" do
    before :each do
      @slide_text = <<SLIDE
# A Slide
With some text
!NOTES
a simple note
SLIDE
      @slide      = Slide.new(@slide_text, ['foo'])
    end

    it "should set the classname to empty" do
      @slide.classnames.should == ['foo']
    end

    it "should extract the content" do
      @slide.content.should match(/^# A Slide/)
    end

    it "should extract the notes" do
      @slide.notes.should match(/a simple note/)
    end

    describe "when generating HTML" do

      it "should assign the classname(s) to the section"

      it "should convert the content via Markdown"

      it "should highlight any code fragments"

    end
  end

  describe "with multiple names" do
    before :each do
      @slide_text = <<SLIDE
# A Slide
With some text
!NOTES
a simple note
SLIDE
      @slide      = Slide.new(@slide_text, ['foo', 'bar'])
    end

    it "should set the classname to empty" do
      @slide.classnames.should == ['foo', 'bar']
    end

    it "should extract the content" do
      @slide.content.should match(/^# A Slide/)
    end

    it "should extract the notes" do
      @slide.notes.should match(/a simple note/)
    end

    describe "when generating HTML" do

      it "should assign the classname(s) to the section"

      it "should convert the content via Markdown"

      it "should highlight any code fragments"

    end
  end

end
