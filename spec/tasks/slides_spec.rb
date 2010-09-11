require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Keydown, "`slides`" do
  before :each do
    @tmp_dir = "#{Dir.tmpdir}/keydown_test"
    FileUtils.rm_r @tmp_dir if File.exists?(@tmp_dir)
    FileUtils.mkdir_p @tmp_dir

    @thor    = Thor.new
  end

  describe "with defaults" do

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

  describe "with custom CSS" do
    before(:each) do
      Dir.chdir @tmp_dir do
        @thor.invoke Keydown, "generate", "test"

        Dir.chdir "test" do

          system "cp #{Keydown.source_root}/spec/fixtures/with_title.md #{@tmp_dir}/test/with_title.md"
          system "cp #{Keydown.source_root}/spec/fixtures/custom.css #{@tmp_dir}/test/css/custom.css"

          @thor.invoke Keydown, "slides", "with_title.md"

          @file = File.new('with_title.html')
          @doc  = Nokogiri(@file)
        end
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

    xit "should include any custom CSS file from the css directory" do
      @doc.css('style[title=test\.css]').length.should == 1
      @doc.css('style[title=custom\.css]').length.should == 1
    end

  end
end
