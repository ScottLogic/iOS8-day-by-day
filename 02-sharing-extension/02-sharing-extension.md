# iOS8 Day-by-Day :: Day 2 :: Sharing Extension

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the introduction page,
but have a read through the rest of this post first!

---

## Introduction

A __huge__ new feature in iOS8 is the introduction of support for extensions.
These are areas in which developers can enhance the operating system, including
both 3rd-party apps and Apple-provided apps, with their own features and
functionality. There are 6 extensions applicable to iOS:

- Today screen widgets
- Share extensions
- Actions
- Photo editing
- Storage providers
- Custom keyboards

We'll cover some of these in later editions of iOS8 Day-by-Day, but today's article
is focussed on sharing extensions.

Sharing extensions give you, the developer of an app, to show an icon on the
common share-sheet, and then to handle the sharing of the content the user has
requested. This means that you can supplement the list of possibilities present
in the OS (e.g. Twitter, Flickr, Sina Weibo).

A word of warning: this topic is not an easy one. From the mere nature of an
extension it is pretty complex. The article will take you through some of the
most common use cases, but be aware that you can pretty much build your own
visual appearance. Apple has some excellent resources in this area, so it's
worth having a read through them if you get stuck with anything.

The sample app for today's post is called "ShareAlike", and demonstrates building
a sharing extension which allows sharing an image and some text. The code is
available on Github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Creating a share extension


### Specifying what can be shared


## Uploading from within an extension


### Extracting an image to upload


### Creating a shared container



## Conclusion

Sharing extensions are just one of the extensions available to developers in iOS8,
and represents Apple opening up the operating system in a way they've been
asked to do for a while. Interestingly, it's done in a way that has prioritized
security and privacy, arguably at a small cost of customisability.

Building sharing extensions is far from trivial, and along the route there are
many things that can trip you up. However, if it's applicable to you and your app
then it's definitely worth investing the time in. The API is good, and the gain
to your users could be huge.

The code for this project is available on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
In order to get the uploading working, you will need to ensure that you've got
a shared container configured correctly, although the project file should do
most of that for you.

Look out for future articles in the iOS8 Day-by-Day series which will investigate
some of the other new extensions available in iOS8.

Any questions / comments / complaints then drop me a tweet - I'm
[@iwantmyrealname](https://twitter.com/iwantmyrealname).


sam
