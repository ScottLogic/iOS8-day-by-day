# iOS8 Day-by-Day :: Day 34 :: CoreLocation Authorization

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

CoreLocation is the framework which gives you access to the geo-location
functionality of devices within iOS. You'd use if you wanted to find the user's
currently location. The functionality provided by CoreLocation is obviously very
sensitive - it's important for users to be able to manage their privacy. In iOS7
and before, CoreLocation provided this functionality automatically, but this is
no longer the case.

In today's article you'll discover the different options for privacy with
CoreLocation introduced in iOS8, and how you need to update your apps to use
them.

The app which accompanies today's post is a simple route tracking app called
__Where Am I?__. It registers for updates from CoreLocation, displays them on
screen and plots the route on a map. You can get hold of the source code for
__Where Am I?__ on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Refresher on CoreLocation


## New Methods on CoreLocationManager


## Providing Usage Strings


## Conclusion
