class Keydown < Thor

  desc "slides FILE", "Convert a Keydown FILE into an HTML presentation"
  def slides(file)

    file += '.md' unless file.match(/\.md$/)

    unless File.exist?(file)
      say "#{file} not found. Please call with a KeyDown Markdown file: keydown slides my_file.md", :red
      return
    end

    @@template_dir = File.join(Keydown.source_root, 'templates', 'rocks')

    slide_deck     = SlideDeck.new(File.new(file).read)
    backgrounds    = slide_deck.slides.collect do |slide|
      slide.background_image unless slide.background_image.empty?
    end.compact

    generate_css_for_backgrounds(backgrounds) unless backgrounds.empty?

    presentation   = file.gsub('md', 'html')

    say "Creating KeyDown presentation from #{file}", :yellow
    create_file presentation do
      slide_deck.to_html
    end
  end

  no_tasks do
    def generate_css_for_backgrounds(backgrounds)
      css_template  = File.new(File.join(Keydown.template_dir, '..', 'keydown.css.erb'))
      create_file 'css/keydown.css' do
        ERB.new(css_template.read).result(binding)
      end
    end
  end
end