# iOS8 Day-by-Day :: Day 21 :: Alerts and Popovers

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

Presenting new views and view controllers to users on iOS has evolved a lot
since the original iPhoneOS. This has resulted in a pretty inconsistent state in
iOS7 - with some presentation methods being device restrictive, and others
creating views in second UIWindow objects.

iOS8 introduces the concept of a presentation controller, in the form of 
`UIPresentationController`. This is used to control the process of presenting
new view controllers in every scenario. This means that the way you use alerts,
popovers and action sheets has changed, to make a much more coherent and self-
consistent system.

This post won't go into depth on presentation controllers (that may well appear
in a later article), but instead focuses on what you need to know to update your
apps to the new iOS8 way of presenting popovers, alerts and action sheets.

The sample app which accompanies this project is available on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).

## Pop Overs


## Alerts


## ActionSheets


## Conclusion

It's great when Apple take a look back at existing parts of the framework and
consolidate the way in which it works. This section of UIKit had evolved over
many years, and was in need of modernization. The quest for adaptivity and
becoming device agnostic has made it an ideal time to rethink the way they work.
It's an area that you should make sure you are aware of - it's a lot more
understandable than it used to be.

As ever, all the code for today's article is available on the ShinobiControls
github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
Let me know what you think on twitter 
[@iwantmyrealname](https://twitter.com/iwantmyrealname).


sam


