require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Keydown do
  before :each do
    @tmp_dir = "#{Dir.tmpdir}/keydown"
    FileUtils.rm_r @tmp_dir if File.exists?(@tmp_dir)
    FileUtils.mkdir_p @tmp_dir

    @thor    = Thor.new
  end

  describe "slides command with defaults" do

    before :each do
      system "cp -r spec/fixtures/with_title.md #{@tmp_dir}"
    end

    describe "should generate an html file that" do
      before(:each) do
        Dir.chdir @tmp_dir do
          @thor.invoke Keydown, "slides", "with_title.md"
          @file = File.new('with_title.html')
          @doc  = Nokogiri(@file)
        end
      end

      it "should have the correct file name" do
        @file.should_not be_nil
      end

      it "should set the document's title" do
        @doc.css('title').text.should == "Kermit the Frog Says..."
      end

      it "should generate the correct number of slides" do
        @doc.css('div.slide').length.should == 3
      end

      describe "should have one slide that" do
        before :each do
          @slide = @doc.css('div.slide section')[2]
        end

        it "should have the correct css class(es)" do
          @slide['class'].should match /foo/
          @slide['class'].should match /bar/
        end

        it "should have the correct content" do
          @slide.css('h1').text.should match /The Letter Q/
        end

      end
    end
  end
end
