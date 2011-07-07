# KeyDown

KeyDown is another 'Presentation System in a single HTML page' inspired by [Showoff](http://github.com/dirnic/showoff/), [Slidedown](http://github.com/nakajima/slidedown),
[HTML5 Rocks](http://studio.html5rocks.com/#Deck), with a little [Presentation Zen](http://amzn.to/8X55H2) thrown in.

## Usage

### Generate a Template

Get started by making a sample project:

    $ keydown generate my_presentation

This will make:

    | - my_presentation/
      | - css/               - Keydown CSS and a file for you to customize
      | - images/            - Some Keydown images, but also for you
      | - js/                - Keydown JavaScript, and a file for you to customize
      | - my_presentation.md

### Write your presentation in Markdown

Edit `my_presentation.md` and write your presentation as if it were going to be HTML (because it will be):

    !SLIDE
    
    # This is my talk
    
    !SLIDE
    
    ## I hope you enjoy it
    
    !SLIDE code
    
        def foo
          :bar
        end
    
	!NOTES
	
	  * make sure to explain the use of Ruby symbols	
	
    !SLIDE
    
    Google is [here](http://google.com)
    
    !SLIDE
    
    # Questions?

`!NOTE` blocks will be ignored when generating the HTML.

### Generate the Deck

    $ keydown slides my_presentation.md

..will generate `my_presentation.html`

### Present

Give your presentation! Open `my_presentation.html` in a browser and talk away:

  * left, right arrows to navigate through slides

## Usage

### Presentation Title

An optional first `H1` before a `!SLIDE` is treated as the presentation title. It will be on the configuration page and set as the HTML `<title>`.
	
### Configuration Page & Navigation

The first page of a Keydown presentation is a configuration page that shows the presentation title, how to navigate the presentation, and some visual effect options.

### Slide classes

Any text that follows `!SLIDE` will be added to the slide as CSS classes. 

    !SLIDE dark

There are some built-in classes you can use:

* `middle` will center all the elements on the slide
* `bulleted` - by default, lists to not have bullets; use this class to add them back
* `dark` - by default, slides are light with dark fonts; this swaps a slide

You can define your own CSS classes (see below).

### Images 

Your presentation will be generated in the same directory as your Markdown file. So URI references via relative paths
are fine.  So feel free to use the local images directory (see the `generate` task above).

### Full Screen background images

Keydown supports slides with full screen background images, including attribution text.

    !SLIDE
    
    # This slide has a background image
    
    }}} images/sunset.jpg

This slide will have `sunset.jpg` as a full-bleed background image. It's aspect ratio will be preserved.

If you wish to have attribution text, an icon (currently Flickr and Creative Commons graphics are supported via `flickr` and `cc` respectively), and link the text, separate the text with `::` like this:


    !SLIDE
    
    # This slide has a background image
     
    }}} images/sunset.jpg::cprsize::flickr::http:://flickr.com/cprsize

### Syntax Highlighting

Code syntax highlighting is done via [Pygments](http://pygments.org), which must be installed locally to work. All Pygments lexers are supported.

Mark your code by block escaping via `@@@` or ` ``` `

For Ruby:

    @@@ ruby
        def foo
          :bar
        end
    @@@

For JavaScript

    ``` js
        function foo() {
          return 'bar';
        }
    ```

For ERb:

    @@@ rhtml
        <%= @post.created_at.to_s(:fancy) %>
    @@@

### Custom CSS

All css files in the `css` directory will be linked into your presentation HTML file.

### Custom JavaScript.

All JavaScript files in the `js` directory will be linked in your presentation HTML file.

## Requirements

### For Use

   * Ruby and Rubygems
   * [Pygments](http://pygments.org) is required for code syntax highlighting
   * Other dependent gems will be installed

### For Development

   * RSpec
   * Nokogiri

## Note on Patches/Pull Requests
 
  * Fork the project.
  * Make your feature addition or bug fix.
  * Add tests for it. This is important so I don't break it in a future version unintentionally.
  * Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
  * Send me a pull request. Bonus points for topic branches.

## Thanks & Attribution

Thanks to:

* HTML5 Rocks guys for a great presentation template
* [@nakajima](http://twitter.com/nakajima) & [Slidedown](http://github.com/nakajima/slidedown) for some parsing
* The various Github guys for Albino, Gollum, etc.

## Copyright

Copyright &copy;  Infews LLC. See LICENSE for details.
