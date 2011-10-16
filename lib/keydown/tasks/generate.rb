module Keydown
  class Tasks < Thor
    attr_reader :presentation_name

    desc "generate NAME", "Make a directory & sample files for presentation NAME"

    def generate(name)
      @presentation_name = name # instance variable used when the directory is copied
      directory "templates/generate", name

      copy_file "templates/generate/deck.js/themes/transition/horizontal-slide.css", "#{name}/css/horizontal-slide.css"
      copy_file "templates/generate/deck.js/themes/style/swiss.css", "#{name}/css/swiss.css"
      copy_file "templates/generate/deck.js/extensions/codemirror/themes/default.css", "#{name}/css/default.css"
    end
  end
end