module Keydown
  class Slide

    attr_reader :content
    attr_reader :notes
    attr_reader :background_image
    attr_reader :classnames

    def initialize(text, classnames = '')
      @notes = ''
      @background_image = {}

      @codemap = CodeMap.build_from(text)
      @content = @codemap.mapped_text

      extract_notes!
      extract_content!
      extract_background_image!

      @classnames = Classnames.new('slide')
      @classnames.add(classnames)

      unless @background_image.empty?
        @classnames.add('full-background')
        @classnames.add(@background_image[:classname])
      end
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
                               :classnames => classnames.to_hash,
                               :background_attribution_classnames => background_attribution_classnames,
                               :background_image => background_image)

      slide = Tilt.new(File.join(Tasks.template_dir, 'slide.html.haml'))
      html = slide.render(context)

      @codemap.put_code_in html
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

    def extract_code(text)
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
  end
end