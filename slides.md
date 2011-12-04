# Keydown Sample Presentation

!SLIDE

# Keydown

## Markdown + [deck.js](http://imakewebthings.github.com/deck.js)

Yet another single-page HTML presentation maker

!SLIDE 

## So you need to make a presentation...

!SLIDE bottom-left

# And you're not this guy

}}} images/steve.jpg

!SLIDE top-right

# You're this guy

}}} images/constructocat.jpg

!SLIDE left

## Markdown > Powerpoint
## HTML, CSS, JS > Keynote

!SLIDE left

# Keydown

1. `$ gem install keydown`
1. `$ keydown generate my_presentation`
1. Write your presentation in Markdown
1. Customize with CSS
1. `keydown slides`

!SLIDE

#### boom.

!SLIDE

## You're soaking in it

!SLIDE

## Interested?

Take a look...

!SLIDE

The previous slide looks just like this:

```Markdown

&#33;SLIDE

## Interested?

Take a look...

```

!SLIDE left

# You can even drop the centering

* So that your bullets
* Look just like your audience
* Expects them to look

!SLIDE

```Markdown
&#33;SLIDE left

# You can even drop the centering

* So that your bullets
* Look just like your audience
* Expects them to look

```

!SLIDE snazzy-slide

# Or have a specific slide have its own CSS

!SLIDE

### The presentation

```Markdown
&#33;SLIDE snazzy-slide

# Or have a specific slide have its own CSS
```

### Custom CSS file

```css
@import url(http://fonts.googleapis.com/css?family=Permanent+Marker);

.slide.snazzy-slide .content h1 {
  -webkit-transform: rotate(-27deg);
  color: #4b0082;
  font-style: italic;
  font-family: "Permanent Marker", serif;
}
```

!SLIDE bottom-left

# Or a full-bleed background (with attribution)

}}} images/cosplay.jpg::luccacomicsandgames::flickr::http://www.flickr.com/photos/luccacomicsandgames/6295021686/


!SLIDE

```Markdown
&#33;SLIDE bottom-left

# Or a full-bleed background (with attribution)

}}} images/cosplay.jpg::luccacomicsandgames::flickr::http://www.flickr.com/photos/luccacomicsandgames/6295021686/
```

!SLIDE

## Add your own CSS, JavaScript

### No server required - just add the files to the project directory

!SLIDE left

## `$ keydown slides` 
## Builds a [deck.js](http://imakewebthings.github.com/deck.js) presentation

* Some deck.js extensions are included 
* Add/remove as you need

!SLIDE

# Present anywhere 

## ...you can launch a browser

!SLIDE

# Thanks.

### [@dwfrank](http://twitter.com/dwfrank) | [infews](http://github.com/infews) on Github

#### Made with [Keydown](http://github.com/infews/keydown)



