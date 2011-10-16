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
      File.directory?(project_dir).should be_true
    end

    it "should generate a sample Markdown file" do
      File.exist?("#{project_dir}/slides.md").should be_true
    end

    it "should create the support directories for the presentation" do
      File.directory?("#{project_dir}/css").should be_true
      File.directory?("#{project_dir}/images").should be_true
      File.directory?("#{project_dir}/js").should be_true
    end

    it "should copy the deck.js core files" do
      File.exist?("#{project_dir}/deck.js/core/deck.core.css").should be_true
      File.exist?("#{project_dir}/deck.js/core/deck.core.js").should be_true
    end

    it "should copy deck.js's support files" do
      File.exist?("#{project_dir}/deck.js/support/jquery.1.6.4.min.js").should be_true
      File.exist?("#{project_dir}/deck.js/support/modernizr.custom.js").should be_true
    end

    it "should copy the deck.js extensions" do
      File.directory?("#{project_dir}/deck.js/extensions").should be_true

      extensions = Dir.glob("#{project_dir}/deck.js/extensions/*")
      extensions.length.should > 1
      extensions.should include("#{project_dir}/deck.js/extensions/codemirror")
    end
  end
end