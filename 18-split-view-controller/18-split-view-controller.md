# iOS8 Day-by-Day :: Day 18 :: UISplitViewController

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

If you've used Xcode's master-detail template in the past then you'll be aware
of the rather confusing code that it creates. This is because it uses two
completely different view controller hierarchies depending on the device it's
running on. The split view controller works on the iPad, but not the iPhone, so
a navigation controller is used instead. This means that the code is littered
with idiom checks and repetition.

The fundamental principle is sound - you can't use the same view controller
hierarchy on all devices. However, there is no reason that this shouldn't be
abstracted away from the developer into the framework itself. This is exactly
what iOS8 does - with the introduction of adaptive view controller hierarchies.

In the master-detail scenario this means that a UISplitViewController can now be
used on all devices. It retains the same appearance on an iPad as in iOS7, but
on an iPhone it appears as a navigation controller.

In today's article you're going to learn more about what this means for your
code, and how you can override the default behavior. The accompanying project is
based on the master-detail project template in Xcode 6, so uses the new split
view controller. You can download the code from the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Conclusion
