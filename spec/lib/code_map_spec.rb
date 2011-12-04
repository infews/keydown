require 'spec_helper'

describe Keydown::CodeMap do
  before :each do
    module Keydown
      class Tasks
        def self.template_dir
          File.join(Keydown::Tasks.source_root, 'templates', 'deck.js')
        end
      end
    end
  end

  let :ruby_block do
    %{@@@ ruby
def a_method(options)
  puts "I can has options " + options
end
@@@}
  end

  let :md_block do
    %{``` Markdown
# I'm an H1

* list item 1
* list item 2
* list item 3
```}
  end

  let :slide_text do
    slide_text = <<-SLIDE
# A Slide
With some text

#{ruby_block}

#{md_block}

!NOTES
a simple note

    SLIDE
  end

  before :each do
    @map = Keydown::CodeMap.new(slide_text)
    @map.build
    @text = @map.mapped_text
  end

  it "should replace each code block with a marker" do
    @text.should_not match(/ruby/)
    @text.should_not match(/@@@/)
    @text.should match(@map.nodes.keys[0])
    @text.should_not match(/Markdown/)
    @text.should_not match(/```/)
    @text.should match(@map.nodes.keys[1])
  end

  it "should find all the code segments" do
    @map.length.should == 2
  end

  it "should find and encode a code block in @@@" do
    code_id =@map.nodes.keys[0]
    @html = Nokogiri(@map[code_id])

    @html.css('textarea').length.should == 1
    @html.css('textarea').attr('mode').value.should == 'ruby'
    @html.css('textarea').text.should match(/a_method/)
  end

  it "should find a code block in ```" do
    code_id =@map.nodes.keys[1]
    @html = Nokogiri(@map[code_id])

    @html.css('textarea').length.should == 1
    @html.css('textarea').attr('mode').value.should == 'Markdown'
    @html.css('textarea').text.should match(/I'm an H1/)
  end

  describe ".build_form" do
    before :each do
      @map = Keydown::CodeMap.build_from(slide_text)
    end

    it "should return a built CodeMap" do
      @map.length.should == 2
    end
  end
end