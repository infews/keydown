class Slide

  attr_reader :classnames
  attr_reader :content
  attr_reader :notes

  def initialize(text, classnames = '')
    @text = text
    @classnames = classnames
    @notes = ''

    extract_notes
    extract_content
  end

  def extract_content
    @content = @text.gsub(/^!NOTES\s*(.*\n)$/m, '')
  end

  def extract_notes
    match_data = @text.match(/^!NOTES\s*(.*\n)$/m)

    @notes = match_data[1] if match_data
  end

  def to_html
    require 'erb'
    require 'rdiscount'

    html_content = RDiscount.new(@content).to_html

    template = File.new(File.join('templates', 'rocks', 'slide.rhtml'))
    ERB.new(template.read).result(binding)
  end

end