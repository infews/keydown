# KeyDown

KeyDown is another 'Presentation System in a single HTML page' inspired by [Showoff](http://github.com/dirnic/showoff/), [Slidedown](http://github.com/nakajima/slidedown),
[HTML5 Rocks](http://studio.html5rocks.com/#Deck), with a little [Presentation Zen](http://amzn.to/8X55H2) thrown in.

In fact, to be fair, the Markdown parsing code is straight-up lifted from Slidedown and some of the markup code was taken from Github Markup/Gollum. So Keydown uses a hybrid approach to
the markup...

## Usage

### Generate a Template

Get started by making a sample project:

    $ keydown generate my_presentation

This will make:

    | - my_presentation/
      | - css/
      | - images/
      | - js/
      | - my_presentation.md

### Write your presentation in Markdown

Edit `my_presentation.md`

    !SLIDE

    # This is my talk

    !SLIDE

    ## I hope you enjoy it

    !SLIDE code

        def foo
          :bar
        end

	!NOTES
	
	  * make sure to explain the use of symbols	
	
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

## Advanced Usage

### Images 

Your presentation html will be generated in the same directory as your Markdown file. So URI references via relative paths
are fine.  So feel free to have a local images directory (see the `generate` task above).

### Syntax Highlighting

Code syntax highlighting is done via [Pygments](), which must be installed, so all Pygments lexers are supported.

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

All css files in the `css` directory will be placed inline in your presentation HTML file.

### Custom JavaScript.

All JavaScript files in the `js` directory will be placed inline in your presentation HTML file.

## Requirements

### For Use

   * [Pygments]() is required for code syntax highlighting
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

## Copyright

Copyright (c) 2010 Infews LLC. See LICENSE for details.
