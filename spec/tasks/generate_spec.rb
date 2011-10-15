require 'spec_helper'

describe Keydown do
  
  let :tmp_dir do
    "#{Dir.tmpdir}/keydown"    
  end
  
  before :each do
    FileUtils.rm_r tmp_dir if File.exists?(tmp_dir)
    FileUtils.mkdir_p tmp_dir

    @thor = Thor.new
  end

  describe "generate command" do
    before :each do
      capture_output do
        Dir.chdir tmp_dir do
          @thor.invoke Keydown::Tasks, ["generate", "sample"]
        end
      end
    end

    it "should generate a directory for the presentation" do
      Dir.chdir "#{tmp_dir}" do
        File.directory?('sample').should be_true
      end
    end

    it "should generate a sample Markdown file" do
      Dir.chdir "#{tmp_dir}/sample" do
        File.exist?("slides.md").should be_true
      end
    end

    it "should create the support directories for the presentation" do
      Dir.chdir "#{tmp_dir}/sample" do
        File.directory?("css").should be_true
        File.directory?("images").should be_true
        File.directory?("js").should be_true
      end
    end

    it "should copy the deck.js core CSS file" do
      File.exist?("#{tmp_dir}/sample/deck.js/core/deck.core.css").should be_true
    end
    
    it "should copy the deck.js core JS file" do
      File.exist?("#{tmp_dir}/sample/deck.js/core/deck.core.js").should be_true
    end

    it "should copy jQuery.js" do
      File.exist?("#{tmp_dir}/sample/deck.js/support/jquery.1.6.4.min.js").should be_true
    end

    it "should copy the Modernizr file" do
      File.exist?("#{tmp_dir}/sample/deck.js/support/modernizr.custom.js").should be_true
    end
  end
end