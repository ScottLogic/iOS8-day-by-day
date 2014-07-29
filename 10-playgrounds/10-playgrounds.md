# iOS8 Day-by-Day :: Day 10 :: Xcode 6 Playgrounds

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

Playgrounds are a completely new concept in Xcode 6 - bringing the world of a completely interactive code development environment with the powerful new language that is Swift. Using a playground feels very much like a powered-up REPL - combining the persistence of a source code file with the immediate response of a REPL.

Playgrounds are really easy to get started with - in fact when you open Xcode 6 there is an option to create a new playground. You can choose either an iOS playground or an OSX playground, and they only support writing in Swift.

Today's article won't cover many of the basics of playgrounds - it's not difficult to get started, but will instead cover some of the more advanced features available through the __XCPlayground__ framework.

The accompanying project is itself a playground, and is available in the ShinobiControls github repo at [github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day). You'll notice that there are two projects within this repo - one for iOS, one for OSX.

> __Note__: At the time of publication, not all the features are available for iOS (beta 4 of Xcode 6). Therefore, the OSX playground is provided for reference. The code is very similar - with like-for-like exchanges where possible. The code snippets in this article will refer to the iOS version.

The aim of the playground project is to create a view which can draw a cycloid. A cycloid is the name of the curve which is traced by a point on the edge of a wheel as it rotates. This development process is very representative of what you could use a playground for. You can read more about cyloids on [Wikipedia](http://en.wikipedia.org/wiki/Cycloid), and the following image (also from Wikipedia) gives you an idea of what you're going to try and create:

![Cycloid](assets/Cycloid_f.gif)

## Interactive Coding & Timelines


## Custom QuickLook


## Custom View Development


## Conclusion