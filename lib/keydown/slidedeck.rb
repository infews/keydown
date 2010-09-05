class SlideDeck
  attr_reader :title
  attr_reader :slides

  def initialize(text)
    @title = ''
    @slides = []
    @text = text

    extract_title
    extract_classnames!
    extract_slides
  end

  def to_html
    require 'erb'
    template = File.new(File.join('templates', 'rocks', 'index.rhtml'))

    ERB.new(template.read).result(binding)
  end

  private

  def extract_title
    match_data = @text.match(/\A\s*#\s*(.*)$/)

    @title = match_data[1] if match_data
  end

  def extract_classnames!
    @classnames = []
    @text.gsub!(/^!SLIDE\s*([\w\s\-]*)\n/m) do |names|
      @classnames << names.to_s.chomp.gsub('!SLIDE', '')
      "!SLIDE\n"
    end
  end

  def extract_slides
    slides_text = @text.split(/!SLIDE/).reject{|s| s.empty?}
    slides_text[1..-1].each_with_index do |slide_text, i|
      slide_text.gsub(/\A(\n+)/,'').chomp!
      @slides << Slide.new(slide_text, @classnames[i].split(' '))
    end
  end


end