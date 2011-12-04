module Keydown
  class CodeMap

    attr_reader :mapped_text

    def initialize(text)
      @text = text
      @map = {}
    end

    def add(id, node)
      @map[id] = node
    end

    def [](id)
      @map[id]
    end

    def each(&blk)
      @map.send(:each, &blk)
    end

    def length
      @map.keys.length
    end

    def nodes
      @map
    end

    def build
      @mapped_text = @text.gsub(/^(```|@@@) ?(.+?)\r?\n(.+?)\r?\n(```|@@@)\r?$/m) do
        language = $2
        code = $3
        id = Digest::SHA1.hexdigest(code)

        add(id, highlight(code, language))
        id
      end
    end

    def put_code_in(html)
      each do |id, code|
        html.sub!(id, code)
      end

      html
    end

    def self.build_from(text)
      map = CodeMap.new(text)
      map.build
      map
    end

    protected

    def highlight(code, language)
      if code.lines.all? { |line| line =~ /\A\r?\n\Z/ || line =~ /^(  |\t)/ }
        code.gsub!(/^(  |\t)/m, '')
      end

      context = OpenStruct.new :language => language, :code => code
      template = Tilt.new(File.join(Tasks.template_dir, 'code.html.haml'))

      template.render(context)
    end
  end
end