# iOS8 Day-by-Day :: Day 24 :: Presentation Controllers

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the
[introduction page](http://www.shinobicontrols.com/ios8daybyday),
but have a read through the rest of this post first!

---

## Introduction

Back on [day 21](http://www.shinobicontrols.com/blog/posts/2014/08/26/ios8-day-by-day-day-21-alerts-and-popovers/)
you saw how UIKit has been updated to give a more consistent approach to showing
alerts, popovers and action sheets. The technology underlying this uses
presentation controllers, which are new to iOS8. It's possible to provide
your own custom presentation controllers for use in view controller transitions
and presentations.

In today's article you'll learn about what exactly presentation controllers are
for, what they can do and how to create your own. The project which accompanies
today's post is called __BouncyPresent__ and shows how to use a custom
presentation controller to create a customized modal view controller
presentation. It uses some of the view controller transitioning animation
concepts introduced in iOS7 alongside the new presentation controller concepts
to create an easy-to-understand, reusable presentation component.

As ever, the source code is available on the ShinobiControls github, at
[github.com/ShinobiControls/iOS8-day-by-day](https://www.shinobicontrols.com/iOS8-day-by-day).

## The role of the Presentation Controller

Whenever a view controller appears on the screen of an iOS device, it is said to
be presented. The improvements to alerts and the suchlike discussed in day 21
included consolidating all the different techniques into using view controllers,
so that they too become view controller presentations. In order to control how a
view controller is presented, iOS8 introduces `UIPresentationController`.

UIKit uses a presentation controller to manage the presentation of view
controllers from the moment they appear, through their lifetime, until they are
dismissed. The common modal presentation styles (such as popover) have built-in
presentation controllers, which exhibit the desired behavior, but if you
wish to provide your own then you must set the `modalPresentationStyle` to
`.Custom` (further implementation detail will be discussed later).

The presentation controller is responsible for positioning the view controller
which is being presented, and for adding any extra views to the view hierarchy
as appropriate. For example, in the sample app today, the presentation
controller will ensure that the presented view controller is inset from the
container, and a view which appears to dim the background will be added behind
the presented view controller.

On the surface of it, presentation controllers don't allow you to do anything
that you couldn't do before using the view controller transitioning system
in iOS7, but the responsibilities are much clearer. An animation controller is
responsible for the animation and the display of the view controller's content,
and the presentation controller is responsible for the appearance of everything
else. In the past, view controllers were responsible for views which weren't
within their own view hierarchy, which was confusing at best. As you'll see,
presentation controllers control the wider view hierarchy, and have hooks which
allow them to animate alongside the existing animations.

## Creating a custom Presentation Controller

## Custom Presentation Animation

## Conclusion
