module Keydown
  class Tasks < Thor
    attr_reader :presentation_name

    desc "generate NAME", "Make a directory & sample files for presentation NAME"

    def generate(name)
      @presentation_name = name
      directory "templates/generate", name
    end
  end
end