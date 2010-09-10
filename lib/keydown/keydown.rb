class Keydown < Thor
  include Thor::Actions

  attr_reader :presentation_name

  def self.source_root
    File.join(File.dirname(__FILE__), '../..')
  end

  desc "generate NAME", "Make a directory & sample files for presentation NAME"
  def generate(name)
    @presentation_name = name
    directory "templates/generate", name
  end

  desc "slides FILE", "Convert a Keydown FILE into an HTML presentation"
  def slides(file)
    keydown_text = File.new(file).read

    template_dir = File.join(File.dirname(__FILE__), '..', '..', 'templates', 'rocks')

    presentation = file.gsub('md', 'html')

    create_file presentation do
      SlideDeck.new(template_dir, keydown_text).to_html
    end
  end
end