module Keydown
  class SlideDeck

    class Context < OpenStruct
      include HtmlHelpers
    end

    attr_reader :title
    attr_reader :slides

    def initialize(text)
      @title = ''
      @slides = []
      @text = text

      set_title
      extract_classnames!
      build_slides
    end

    def to_html
      require 'tilt'

      css_files = ['css/keydown.css', 'css/default.css',
                   'css/horizontal-default.css', 'css/swiss.css']
      css_files += Dir.glob('css/*.css')
      css_files.uniq!

      extension_dirs = Dir.glob('deck.js/extensions/*').select {|f| File.directory? f}
      extension_css = extension_dirs.inject([]) do |files, dir|
        files += Dir.glob("#{dir}/*.css")
        files
      end

      context = Context.new(:title => @title,
                            :css_files => css_files,
                            :js_files => Dir.glob('js/**/*.js') || [],
                            :slides => @slides,
                            :extensions_js_files => Dir.glob('deck.js/extensions/**/*.js') || [],
                            :extensions_css_files => extension_css)

      template = Tilt.new(File.join(Tasks.template_dir, 'index.html.haml'))
      template.render(context)
    end

    private

    def set_title
      match_data = @text.match(/\A\s*#\s*(.*)$/)

      @title = match_data[1] if match_data
    end

    def extract_classnames!
      @classnames = []
      @text.gsub!(/^!SLIDE\s*([\w\s\-]*)\n/m) do
        @classnames << $1.chomp
        "!SLIDE\n"
      end
    end

    def build_slides
      slides_text = @text.split(/!SLIDE/).reject { |s| s.empty? }
      slides_text[1..-1].each_with_index do |slide_text, i|
        slide_text.gsub(/\A(\n+)/, '').chomp!
        @slides << Keydown::Slide.new(slide_text, @classnames[i])
      end
    end
  end

end