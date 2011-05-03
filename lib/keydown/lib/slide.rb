require 'digest/sha1'
require 'albino'

module Keydown
  class Slide

    attr_reader :content
    attr_reader :notes
    attr_reader :background_image

    def initialize(text, classnames = '')
      @content = text
      @notes = ''
      @codemap = {}
      @background_image = {}

      @classnames = []
      classnames.split(' ').inject(@classnames) do |css_classnames, name|
        css_classnames << name
        css_classnames
      end

      extract_notes!
      extract_content!
      extract_code!
      extract_background_image!
      pygmentize_code!
    end

    def classnames
      @classnames.join(' ')
    end

    def container_classnames
      @names ||= begin
        names = ['slide']

        unless @background_image.empty?
          names << 'full-background'
          names << @background_image[:classname]
        end

        names.join(' ')
      end
    end

    def background_attribution_classnames
      names = ['attribution']

      names << if background_image[:attribution_text]
        background_image[:service]
               else
                 'hidden'
               end

      names.join(' ')
    end

    def to_html
      require 'erb'
      require 'rdiscount'

      html_content = RDiscount.new(@content).to_html
      template = File.new(File.join(Tasks.template_dir, 'slide.rhtml'))

      ERB.new(template.read).result(binding)
    end

    private

    def extract_notes!
      @content.gsub!(/^!NOTE\s*(.*\n)$/m) do
        @notes = $1.chomp
        ''
      end
    end

    def extract_content!
      @content.gsub!(/^!NOTE(S)?\s*(.*\n)$/m, '')
    end

    def extract_code!
      @content.gsub!(/^(```|@@@) ?(.+?)\r?\n(.+?)\r?\n(```|@@@)\r?$/m) do
        id = Digest::SHA1.hexdigest($3)
        @codemap[id] = {:lang => $2, :code => $3}
        id
      end
    end

    def extract_background_image!
      images = []
      @content.gsub!(/^(\}\}\}) ?(.+?)(\r?\n)?$/m) do
        images << $2
        ''
      end

      return unless images.first

      split_line = images.first.split('::')
      image_path = split_line[0]

      @background_image = {:classname => image_path.match(/([\w-]+)\.?[\w]+$/)[1],
                           :path => image_path}

      unless split_line[1].nil? || split_line[1].empty?
        @background_image.merge!({:attribution_text => split_line[1],
                                  :service => split_line[2],
                                  :attribution_link => split_line[3]})
      end
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
end