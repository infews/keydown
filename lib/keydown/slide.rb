module Keydown
  class Slide

    attr_reader :content
    attr_reader :notes
    attr_reader :background_image
    attr_reader :container_classnames
    attr_reader :content_classnames

    def initialize(text, classnames = '')
      @content = text
      @notes = ''
      @codemap = {}
      @background_image = {}

      @content_classnames = Classnames.new(classnames)

      extract_notes!
      extract_content!
      extract_code!
      extract_background_image!

      @container_classnames = Classnames.new('slide')

      unless @background_image.empty?
        @container_classnames.add('full-background')
        @container_classnames.add(@background_image[:classname])
      end

      highlight_code!
    end

    def background_attribution_classnames
      return [] unless background_image[:attribution_text] || background_image[:service]

      ['attribution', background_image[:service]].join(' ')
    end

    def to_html
      require 'tilt'
      require 'rdiscount'

      markdown = RDiscount.new(@content)
      context = OpenStruct.new(:html_content => markdown.to_html,
                               :container_classnames => container_classnames.as_hash,
                               :classnames => @content_classnames.as_hash,
                               :background_attribution_classnames => background_attribution_classnames,
                               :background_image => background_image)

      slide = Tilt.new(File.join(Tasks.template_dir, 'slide.html.haml'))
      slide.render(context)
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

    require "coderay"

    def highlight_code!
      @codemap.each do |id, code_block|
        language = code_block[:lang]
        code = code_block[:code]
        if code.lines.all? { |line| line =~ /\A\r?\n\Z/ || line =~ /^(  |\t)/ }
          code.gsub!(/^(  |\t)/m, '')
        end

        context = OpenStruct.new :language => language, :code => code
        template = Tilt.new(File.join(Tasks.template_dir, 'code.html.haml'))

        @content.gsub!(id, template.render(context))
      end
    end
  end
end