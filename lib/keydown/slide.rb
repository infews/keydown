class Keydown::Slide

  attr_reader :classnames
  attr_reader :content
  attr_reader :notes

  def initialize(template_dir, text, classnames = '')
    @template_dir = template_dir
    @text = text
    @classnames = classnames
    @notes = ''

    extract_notes
    extract_content
  end

  def to_html
    require 'erb'
    require 'rdiscount'

    html_content = RDiscount.new(@content).to_html
    template = File.new(File.join(@template_dir, 'slide.rhtml'))

    ERB.new(template.read).result(binding)
  end

  private

  def extract_content
    @content = @text.gsub(/^!NOTES\s*(.*\n)$/m, '')
  end

  def extract_notes
    match_data = @text.match(/^!NOTES\s*(.*\n)$/m)

    @notes = match_data[1] if match_data
  end

end