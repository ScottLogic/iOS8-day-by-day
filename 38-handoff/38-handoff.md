# iOS8 Day-by-Day :: Day 38 :: Handoff

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

One of the key new concepts introduced at WWDC in 2014 was that of Continuity,
describing the ability to seemlessly switch between devices, and continue your
task. The underlying technology behind Continuity is called Handoff, and it
works across both iOS and Yosemite.

Today's article introduces the just one of the vectors through which Handoff can
work - native iOS app to native iOS app. The app which accompanies the post is
called __MapOff__ and is a simple map view. When you open the app via Handoff on
a different device, then the currently visible region on the first map will be
transferred to the receiving device.

As ever, the code for today's app is available on the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Handoff Logistics

Handoff is based around user activities. These are objects which encapsulate the
current state of what the user is doing, or at least enough to recreate the 
'session' elsewhere. An activity has a type associated with it, which allows the
operating system to determine whether it has an app which can resume a given
activity.

Handoff works by first using bluetooth LE to discover devices in the locality
that are signed in to the same iCloud account. If the current app is handoff
enabled, and it can find a device that is able to resume the current activity,
then the inactive device will show an icon notifying the user that they can
Handoff from one device to the other.

When the user chooses to continue this activity, the sending device will
transfer the activity object to the continuing device, allowing it to continue
the same activity.

As a developer, you can either integrate with Handoff manually, or, if you have
a document-based app, you can rely on the deep integration with `UIDocument`.
This article will take a look at the manual approach - for further details on
integration with `UIDocument`, take a look at the 
[Handoff programming guide](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Handoff/HandoffFundamentals/HandoffFundamentals.html#//apple_ref/doc/uid/TP40014338-CH3-SW1).


## Preparing an App for Handoff




## Resuming an Activity

## Conclusion
