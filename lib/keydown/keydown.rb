class Keydown < Thor
  include Thor::Actions

  attr_reader :template_dir

  desc "slides [FILE]", "Convert a Keydown FILE into an HTML presentation"
  def slides(file)
    keydown_text = File.new(file).read

    template_dir = File.join(File.dirname(__FILE__), '..', '..', 'templates', 'rocks')

    presentation = file.gsub('md', 'html')

    create_file presentation, :verbose => false do
      SlideDeck.new(template_dir, keydown_text).to_html
    end

  end
end