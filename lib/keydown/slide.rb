require 'digest/sha1'
require 'albino'

class Keydown::Slide

  attr_reader :classnames
  attr_reader :content
  attr_reader :notes

  def initialize(template_dir, text, classnames = '')
    @template_dir = template_dir
    @text         = text
    @classnames   = classnames
    @notes        = ''
    @codemap      = {}

    extract_notes!
    extract_content!
    extract_code!
  end

  def to_html
    require 'erb'
    require 'rdiscount'

    pygmentize_code!
    html_content = RDiscount.new(@content).to_html
    template     = File.new(File.join(@template_dir, 'slide.rhtml'))

    ERB.new(template.read).result(binding)
  end

  private

  def extract_notes!
    match_data = @text.match(/^!NOTES\s*(.*\n)$/m)

    @notes = match_data[1] if match_data
  end

  def extract_code!
    @content.gsub!(/^@@@ ?(.+?)\r?\n(.+?)\r?\n@@@\r?$/m) do
      id           = Digest::SHA1.hexdigest($2)
      @codemap[id] = {:lang => $1, :code => $2}
      id
    end
  end

  def extract_content!
    @content = @text.gsub(/^!NOTES\s*(.*\n)$/m, '')
  end

  def pygmentize_code!
    @codemap.each do |id, spec|
      lang = spec[:lang]
      code = spec[:code]
      if code.all? { |line| line =~ /\A\r?\n\Z/ || line =~ /^(  |\t)/ }
        code.gsub!(/^(  |\t)/m, '')
      end
      @content.gsub!(id, Albino.new(code, lang).colorize)
    end
  end

end