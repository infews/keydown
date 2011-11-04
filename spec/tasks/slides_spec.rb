require 'spec_helper'

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

  let :project_dir do
    "#{tmp_dir}/test"
  end

  before :each do
    FileUtils.rm_r tmp_dir if File.exists?(tmp_dir)
    FileUtils.mkdir_p tmp_dir

    @thor = Thor.new

    Dir.chdir tmp_dir do
      capture_output do
        @thor.invoke Keydown::Tasks, ["generate", "test"]
      end
    end
  end

  describe "when file cannot be found" do
    before(:each) do
      Dir.chdir project_dir do
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
      system "cp -r spec/fixtures/with_title.md #{project_dir}"
    end

    describe "should generate an html file that" do
      before(:each) do
        capture_output do
          Dir.chdir project_dir do
            @thor.invoke Keydown::Tasks, ["slides", "with_title.md"]
            @file = File.new('with_title.html')
            @doc = Nokogiri(@file)
          end
        end
      end

      it_should_behave_like "generating a presentation file"

      describe "should have one slide that" do
        before :each do
          @third_slide = @doc.css('.slide')[2]
        end

        it "should have the correct css class(es)" do
          @third_slide['class'].should match /foo/
          @third_slide['class'].should match /bar/
        end

        it "should have the correct content" do
          @third_slide.css('h1').text.should match /The Letter Q/
        end

        it "should have the deck.js files" do
          scripts = @doc.css('script').collect { |tag| tag['src'] }
          scripts.should include('deck.js/support/modernizr.custom.js')
          scripts.should include('deck.js/support/jquery.1.6.4.min.js')
          scripts.should include('deck.js/core/deck.core.js')
        end

        it "should have all of the extension js files" do
          scripts = @doc.css('script').collect { |tag| tag['src'] }

          scripts.should include('deck.js/extensions/codemirror/codemirror.js')
          scripts.should include('deck.js/extensions/codemirror/deck.codemirror.js')
          scripts.should include('deck.js/extensions/codemirror/mode/ruby/ruby.js') # assuming one means all, really
          scripts.should include('deck.js/extensions/goto/deck.goto.js')
          scripts.should include('deck.js/extensions/hash/deck.hash.js')
          scripts.should include('deck.js/extensions/menu/deck.menu.js')
          scripts.should include('deck.js/extensions/navigation/deck.navigation.js')
          scripts.should include('deck.js/extensions/scale/deck.scale.js')
          scripts.should include('deck.js/extensions/status/deck.status.js')
        end
        
        it "should have all of the extension top-level css files" do
          stylesheets = @doc.css('link').collect {|tag| tag['href']}
          
          stylesheets.should include('deck.js/extensions/codemirror/deck.codemirror.css')
          stylesheets.should include('deck.js/extensions/goto/deck.goto.css')
          stylesheets.should include('deck.js/extensions/hash/deck.hash.css')
          stylesheets.should include('deck.js/extensions/menu/deck.menu.css')
          stylesheets.should include('deck.js/extensions/navigation/deck.navigation.css')
          stylesheets.should include('deck.js/extensions/scale/deck.scale.css')
          stylesheets.should include('deck.js/extensions/status/deck.status.css')
        end

        it "should not include any of the extension sub-directory css files" do
          stylesheets = @doc.css('link').collect {|tag| tag['href']}

          stylesheets.should_not include('deck.js/extensions/codemirror/themes/cobalt.css')
        end

      end
    end

    describe "should add an .md extention if one isn't specified" do
      before(:each) do
        capture_output do
          Dir.chdir project_dir do
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

        Dir.chdir project_dir do
          system "cp #{Keydown::Tasks.source_root}/spec/fixtures/with_title.md #{project_dir}/with_title.md"
          system "cp #{Keydown::Tasks.source_root}/spec/fixtures/custom.css #{project_dir}/css/custom.css"
          system "cp #{Keydown::Tasks.source_root}/spec/fixtures/custom.js #{project_dir}/js/custom.js"

          @thor.invoke Keydown::Tasks, ["slides", "with_title.md"]

          @file = File.new('with_title.html')
          @doc = Nokogiri(@file)
        end
      end
    end

    it_should_behave_like "generating a presentation file"

    it "should include any custom CSS file from the css directory" do
      stylesheets = @doc.css('link').collect {|tag| tag['href']}

      stylesheets.should include('css/test.css')
      stylesheets.should include('css/custom.css')
    end

    it "should include any custom JavaScript files from the js directory" do
      scripts = @doc.css('script').collect { |tag| tag['src'] }

      scripts.should include('js/test.js')
      scripts.should include('js/custom.js')
    end
  end

  describe "for a presentation that has background images" do
    before(:each) do
      capture_output do
        Dir.chdir project_dir do
          system "cp #{Keydown::Tasks.source_root}/spec/fixtures/with_backgrounds.md #{tmp_dir}/test/with_backgrounds.md"

          @thor.invoke Keydown::Tasks, ["slides", "with_backgrounds.md"]

          @file = File.new('with_backgrounds.html')
          @doc = Nokogiri(@file)
        end
      end
    end

    it_should_behave_like "generating a presentation file"

    it "should add the keydown.css file (which has the backgrounds) to the css directory" do
      File.exist?("#{tmp_dir}/test/css/keydown.css").should be_true
    end

    it "should build a CSS file with the custom background images definitions" do
      css_contents = File.read("#{tmp_dir}/test/css/keydown.css")

      css_contents.should match(/\.slide\.full-background\.one/)
    end

    it "should add the keydown.css file to the HTML file" do
      @doc.css('link[@href="css/keydown.css"]').length.should == 1
    end
  end
end