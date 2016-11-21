require 'spec_helper'

describe Keydown do

  let :tmp_dir do
    "#{Dir.tmpdir}/keydown"
  end

  let :project_dir do
    "#{tmp_dir}/sample"
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
      File.directory?(project_dir).should be_truthy
    end

    it "should generate a sample Markdown file" do
      File.exist?("#{project_dir}/slides.md").should be_truthy
    end

    it "should create the support directories for the presentation" do
      File.directory?("#{project_dir}/css").should be_truthy
      File.directory?("#{project_dir}/images").should be_truthy
      File.directory?("#{project_dir}/js").should be_truthy
    end

    it "should copy the deck.js core files" do
      File.exist?("#{project_dir}/deck.js/core/deck.core.css").should be_truthy
      File.exist?("#{project_dir}/deck.js/core/deck.core.js").should be_truthy
    end

    it "should copy deck.js's support files" do
      File.exist?("#{project_dir}/deck.js/support/jquery.1.6.4.min.js").should be_truthy
      File.exist?("#{project_dir}/deck.js/support/modernizr.custom.js").should be_truthy
    end

    it "should copy the deck.js extensions" do
      File.directory?("#{project_dir}/deck.js/extensions").should be_truthy

      extensions = Dir.glob("#{project_dir}/deck.js/extensions/*")
      extensions.length.should > 1
      extensions.should include("#{project_dir}/deck.js/extensions/codemirror")
    end

    it "should copy default theme files for deck.js" do
      File.exist?("#{project_dir}/css/horizontal-slide.css").should be_truthy
      File.exist?("#{project_dir}/css/swiss.css").should be_truthy
    end

    it "should copy default them files for codemirror.js" do
      File.exist?("#{project_dir}/css/default.css").should be_truthy
    end

  end
end
