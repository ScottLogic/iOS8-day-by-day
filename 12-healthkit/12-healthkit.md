# iOS8 Day-by-Day :: Day 12 :: HealthKit

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

One of the more consumer-oriented features introduced in iOS8 is that of the
Health app. It was featured in the keynote at WWDC and was... THIS ISN'T
FINISHED.

The underlying technology behind the health app is HealthKit, which is
essentially a structured datastore designed specifically for health data. Not
only is there an schema for health data, but extra concerns such as access
permissions, querying and unit conversion. HealthKit allows app developers to
interact with this datastore - to add and query data points and calculate
statistics.

In today's article you'll get a whistle-stop tour of some of the features of
HealthKit, and see how easy it is to create an app which can save data points
and query the datastore. The accompanying app is called __BodyTemple__ and is
available in the github repo at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Conclusion