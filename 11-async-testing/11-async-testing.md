# iOS8 Day-by-Day :: Day 11 :: Asynchronous Testing

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

This blog series has already taken a look at one of the new features available
in XCTest, the testing framework in Xcode, in the shape of profiling unit tests -
you can check it out in day 6's
[article](http://www.shinobicontrols.com/blog/posts/2014/07/25/ios8-day-by-day-day-6-profiling-unit-tests).
This isn't the only addition to the framework though - and today's topic will
look at one of the other new features in the form of asynchronous testing.

There are many things which can be formulated as asynchronous tasks in your
iOS app - rather than returning a result immediately will instead call a block/closure
you provide when the result is ready. This is generally good practice, since you
can write functions which won't block the current queue whilst they're waiting for
some kind of response. However, this can make unit testing far more difficult -
rather than calling a function and then checking that the result is correct, you
need to somehow check the result of a callback during the unit test.

In the past, there have been add-on testing frameworks which provide this functionality,
but in Xcode 6, you can use XCTest directly.

The project which accompanies this post is called __HorseRace__, and is a very
simple game which animates two horses across the screen. Note, the app itself
is pretty much irrelevant - but its API has asynchronous components that can be
tested. The code for this project is available on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Testing an Asynchronous Method


## Multiple Expectations


## Key-Value Observation Expectation


## Conclusion
