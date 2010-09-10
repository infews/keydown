require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Keydown do
  before :each do
    @tmp_dir = "#{Dir.tmpdir}/keydown"
    FileUtils.rm_r @tmp_dir if File.exists?(@tmp_dir)
    FileUtils.mkdir_p @tmp_dir

    @thor    = Thor.new
  end

  describe "generate command" do
    before :each do
      Dir.chdir @tmp_dir do
        @thor.invoke Keydown, "generate", "sample"
      end
    end

    it "should generate a directory for the presentation" do
      Dir.chdir "#{@tmp_dir}" do
        File.exist?("sample").should be_true
      end
    end

    it "should generate a sample Markdown file" do
      Dir.chdir "#{@tmp_dir}/sample" do
        File.exist?("sample.md").should be_true
      end
    end

    it "should create the support directories for the presentation" do
      Dir.chdir "#{@tmp_dir}/sample" do
        File.exist?("css").should be_true
        File.exist?("images").should be_true
        File.exist?("js").should be_true
      end
    end
  end
end