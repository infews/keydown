class Keydown < Thor

  desc "slides FILE", "Convert a Keydown FILE into an HTML presentation"
  def slides(file)

    file += '.md' unless file.match(/\.md$/)

    unless File.exist?(file)
      say "#{file} not found. Please call with a KeyDown Markdown file: keydown slides my_file.md", :red
      return
    end

    @@template_dir = File.join(Keydown.source_root, 'templates', 'rocks')

    say "Creating Keydown presentation from #{file}", :yellow

    slide_deck     = SlideDeck.new(File.new(file).read)
    backgrounds    = slide_deck.slides.collect do |slide|
      slide.background_image unless slide.background_image.empty?
    end.compact

    css_template  = File.new(File.join(Keydown.template_dir, '..', 'keydown.css.erb'))
    create_file 'css/keydown.css', :force => true do
      ERB.new(css_template.read).result(binding)
    end

    presentation   = file.gsub('md', 'html')

    create_file presentation, :force => true do
      slide_deck.to_html
    end
  end
end