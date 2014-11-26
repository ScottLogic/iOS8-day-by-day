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

In order to Handoff from an app, it needs to prepare an maintain one or more
`NSUserActivity` objects. These encapsulate what the user is currently doing,
allowing it to be resumed on another device. iOS8 introduces some new features
on `UIResponder` for handling user activities - one of which is a `userActivity`
property. Since `UIViewController` is a subclass of `UIResponder`, you can use
the new features to ease the Handoff workflow.

In __MapOff__, the user activity is created and configured in `viewDidLoad()`:

    let activityType = "com.shinobicontrols.MapOff.viewport"
    
    override func viewDidLoad() {
      super.viewDidLoad()
      if userActivity?.activityType != activityType {
        userActivity?.invalidate()
        userActivity = NSUserActivity(activityType: activityType)
      }
      userActivity?.needsSave = true
      ...
    }

A user activity object has an `activityType` property, which allows the system
to determine whether there is an app that can continue the activity. This is a
string, and should be in reverse-DNS form - as shown above.

You'll also notice that you set the `needsSave` property to `true`. Every time
the user interacts with your app, and you need to update the 'resume
instructions', you need to repeat this. This property allows the system to
lazy batch updates rather than with every user interaction. When this property
is set to `true`, the system will periodically call `updateUserActivityState()`
on your `UIViewController` subclass. This gives you an opportunity to save the
state.

In __MapOff__, this method is used to get the currently visible range from the
map, and save it into the `userInfo` dictionary:

    override func updateUserActivityState(activity: NSUserActivity) {
      let regionData = NSData(bytes: &mapView.region, length: sizeof(MKCoordinateRegion))
      activity.userInfo = ["region" : regionData]
    }

The `userInfo` dictionary can use simple types such as `NSString`, `NSNumber`,
`NSData`, `NSURL` etc. Since these types don't include the `MKCoordinateRegion`
struct, it's necessary to pack it into an `NSData` object. Note that you might
expect to use some kind of archiver, but `MKCoordinateRegion` is a pure Swift
struct, so doesn't implement the `NSCoding` protocol. Since it is a struct
value-type (i.e. doesn't contain references to non-value objects) it's possible
to use `NSData` to copy the bytes. __This won't always be the case__, so be
careful.

As mentioned before, the `needsSave` property should be set to `true` every time
the state of the UI updates. In __MapOff__ this occurs every time the user pans
or zooms the map - i.e. the region changes. Implementing the following delegate
method has the desired effect:

    // MARK:- MKMapViewDelegate
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
      userActivity?.needsSave = true
    }

At this point, you've implemented everything you need to for an app to advertise
that it supports Handoff, but you also need an app that the user can resume
their activity on.

## Resuming an Activity

## Conclusion
