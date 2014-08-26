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

Popovers are now completely adaptive - which means that rather than having
separate code paths for iPhone and iPad, they can be used on every device. A new
class `UIPopoverPresentationController` has been introduced, and this controls
the presentation of a view controller in a popover style. You don't create one
of these directly, but instead one is created for you by UIKit when the 
`modalPresentationStyle` property on `UIViewController` is set to `.Modal`.

    let popoverVC = storyboard.instantiateViewControllerWithIdentifier("codePopover") as UIViewController
    popoverVC.modalPresentationStyle = .Popover

You can then get hold of the popover presentation controller from the
`popoverPresentationController` property of `UIViewController`:

    let popoverController = popoverVC.popoverPresentationController

This has settings that you'll recognize from `UIPopoverController` which you can
use to configure the popover:

    popoverController.sourceView = sender
    popoverController.sourceRect = sender.bounds
    popoverController.permittedArrowDirections = .Any

Then, presenting the popover is as simple as calling `presentViewController()`:

    presentViewController(popoverVC, animated: true, completion: nil)

The popover presentation controller is inherently adaptive - a regular
horizontal size class will show a traditional popover, but a compact will (by
default) present using a full-screen modal presentation.

![Regular width](assets/popover-regular-width.png)
![Compact Width](assets/popover-compact-width.png)

You can configure exactly how the adapted view controller appears (i.e. for 
compact width) using a `UIPopoverPresentationDelegate`. This has two methods -
one for specifying the modal presentation style, and the other for returning a
custom view controller.

You set the delegate as you'd expect:

    popoverController.delegate = self

The adaptive presentation style can be either `.FullScreen` or `.OverFullScreen`,
the difference being that fullscreen will remove the presenting view controller's
view, whereas over-fullscreen won't. You can set it with the following delegate
method:

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
      return .FullScreen
    }

You can see the difference by setting the background color to semi-transparent, 
as shown below:

![FullScreen](assets/popover-fullscreen.png)
![Over FullScreen](aseets/popover-over-fullscreen.png)

The other delegate method allows you to return a completely custom view
controller for the adaptive display. For example, the following will put the
popover view controller inside a navigation controller:

  func presentationController(controller: UIPresentationController!, 
            viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController! {
    return UINavigationController(rootViewController: controller.presentedViewController)
  }

And will result in something that looks like this:

![Popover in Nav Controller](assets/popover-navcontroller.png)

Note that none of this has changed the appearance for regular width - that will
still show as a standard popover controller.

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


