require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Keydown, "`slides`" do

  shared_examples_for "generating a presentation file" do

    it "should have the correct file name" do
      @file.should_not be_nil
    end

    it "should set the document's title" do
      @doc.css('title').text.should == "Kermit the Frog Says..."
    end

    it "should generate the correct number of slides" do
      @doc.css('section.slide').length.should == 3
    end

  end

  let :tmp_dir do
    "#{Dir.tmpdir}/keydown_test"
  end

  before :each do
    FileUtils.rm_r tmp_dir if File.exists?(tmp_dir)
    FileUtils.mkdir_p tmp_dir

    @thor = Thor.new
  end

  describe "when file cannot be found" do
    before(:each) do
      Dir.chdir tmp_dir do
        @std_out = capture_output do
          @thor.invoke Keydown::Tasks, ["slides", "with_title.md"]
        end
      end
    end

    it "should warn the user" do
      @std_out.should match(/not found\. Please call with a KeyDown Markdown file: keydown slides my_file\.md/)
    end

    it "should not write out a file" do
      Dir.glob("#{tmp_dir}/*.html").should be_empty
    end

  end

  describe "with defaults" do

    before :each do
      system "cp -r spec/fixtures/with_title.md #{tmp_dir}"
    end

    describe "should generate an html file that" do
      before(:each) do
        capture_output do
          Dir.chdir tmp_dir do
            @thor.invoke Keydown::Tasks, ["slides", "with_title.md"]
            @file = File.new('with_title.html')
            @doc = Nokogiri(@file)
          end
        end
      end

      it_should_behave_like "generating a presentation file"

      describe "should have one slide that" do
        before :each do
          @third_slide = @doc.css('section')[2].css('div')[0]
        end

        it "should have the correct css class(es)" do
          @third_slide['class'].should match /foo/
          @third_slide['class'].should match /bar/
        end

        it "should have the correct content" do
          @third_slide.css('h1').text.should match /The Letter Q/
        end
      end
    end

    describe "should add an .md extention if one isn't specified" do
      before(:each) do
        capture_output do
          Dir.chdir tmp_dir do
            @thor.invoke Keydown::Tasks, ["slides", "with_title"]
            @file = File.new('with_title.html')
            @doc = Nokogiri(@file)
          end
        end
      end

      it_should_behave_like "generating a presentation file"

    end
  end

  describe "with directory tree with custom CSS & JS" do
    before(:each) do
      capture_output do

        Dir.chdir tmp_dir do
          @thor.invoke Keydown::Tasks, ["generate", "test"]
         puts Dir.pwd
          Dir.chdir "test" do
            system "cp #{Keydown::Tasks.source_root}/spec/fixtures/with_title.md #{tmp_dir}/test/with_title.md"
            system "cp #{Keydown::Tasks.source_root}/spec/fixtures/custom.css #{tmp_dir}/test/css/custom.css"
            system "cp #{Keydown::Tasks.source_root}/spec/fixtures/custom.js #{tmp_dir}/test/js/custom.js"

            @thor.invoke Keydown::Tasks, ["slides", "with_title.md"]

            @file = File.new('with_title.html')
            @doc = Nokogiri(@file)
          end
        end
      end
    end

    it_should_behave_like "generating a presentation file"

    it "should include any custom CSS file from the css directory" do
      @doc.css('link[@href="css/test.css"]').length.should == 1
      @doc.css('link[@href="css/custom.css"]').length.should == 1
    end

    it "should include any custom JavaScript files from the js directory" do
      @doc.css('script[@src="js/test.js"]').length.should == 1
      @doc.css('script[@src="js/custom.js"]').length.should == 1
    end
  end

  describe "for a presentation that has background images" do
    before(:each) do
      capture_output do

        Dir.chdir tmp_dir do
          @thor.invoke Keydown::Tasks, ["generate", "test"]

          Dir.chdir "test" do
            system "cp #{Keydown::Tasks.source_root}/spec/fixtures/with_backgrounds.md #{tmp_dir}/test/with_backgrounds.md"

            @thor.invoke Keydown::Tasks, ["slides", "with_backgrounds.md"]

            @file = File.new('with_backgrounds.html')
            @doc = Nokogiri(@file)
          end
        end
      end
    end

    it_should_behave_like "generating a presentation file"

    it "should add the keydown.css file (which has the backgrounds) to the css directory" do
      File.exist?("#{tmp_dir}/test/css/keydown.css").should be_true
    end

    it "should add the keydown.css file to the HTML file" do
      @doc.css('link[@href="css/keydown.css"]').length.should == 1
    end

  end
end