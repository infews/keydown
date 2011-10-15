Deck.js-CodeMirror Extension
============================

This extension allows you to embed codemirror code snippets in your slides. Those codeblocks
can also be executable, which is pretty exciting.

An example is running here: http://ireneros.com/deck/codemirror-introduction

# Installation: #

Move all this into a folder called 'codemirror' in your deck.js/extensions/ folder.

# Setup: #

Include the stylesheet:

    <link rel="stylesheet" href="../extensions/codemirror/deck.codemirror.css">

Include the JS source:

    <script src="../extensions/codemirror/deck.codemirror.js"></script>

Include your favorite CodeMirror syntax style:

    <link rel="stylesheet" href="../extensions/codemirror/themes/default.css">

  Options are:
    
    cobalt.css
    default.css
    elegant.css
    neat.css
    night.css

# Use: #

There are two ways to create code blocks:
Inside your slide:

## Text Area:

    <div>
      <textarea id="code" name="code" class="code" mode="javascript" style="display: none;" runnable="true">// codemirror demo party!
        var greeter = function(name) {
          return "Why hello there " + name;
        }
        console.log(greeter("Joe"));
      </textarea>
    </div>
  
## Any other item:

    <div>
      <div id="code" name="code" class="code" mode="javascript" style="display: none;">// codemirror demo party!
        var obj = { text : "Hello all!"};
        console.log("HI THERE");
      </div>
    </div>

# Element Attributes: #

Regardless of your element type, the following attributes should be set:

* class - code (should always be set to code.)
* mode  - language mode. Supported Modes:
 * javascript
 * yaml
 * ruby
 * text/html (needs to be specified this way)
 * xml
* theme (optional) - If you want multiple themes in your slides, include multiple stylesheets and set this attribute to the theme name.
* runnable (optiona) - If true, will add a Run button to the window and pipe the eval's console output to an output element right below. 

# Contact: #
Irene Ros (@ireneros)
http://bocoup.com

    
