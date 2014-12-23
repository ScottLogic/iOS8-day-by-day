# iOS8 Day-by-Day :: Day 39 :: WatchKit

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

Although the Apple Watch was unveiled back in September 2014, developers have
only recently got hold of an SDK - hidden away inside iOS 8.2. It seems that the
Apple Watch has really caught the imagination of iOS developers from across the
world, and as such there have been loads of in-depth articles, opinion pieces
and videos created covering it. iOS8 Day-by-Day has always been intended to be
short overview of new technologies so that intermediate developers can hit the
ground running. Today's post on Apple Watch is no different. If you want to
learn everything there is to know about the SDK then read the documentation, and
then soak up the excellent content that's been created in the short time the SDK
has been alive.

This post will discuss what's different between an iOS app, and an Apple Watch
app, what we can do as developers, and a very quick guide to getting started.
The app that accompanies this post is called __NightWatch__ and provides the
wearer with instant access to some of the best quotes from this excellent movie.
(Well, I say excellent, I've never seen it, and hadn't actually heard of it until
I started this project.) The source code for the app is available on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).

## What can (and can't) I do on a watch?

Apple has made it very clear that the Apple Watch SDK in iOS 8.2 is the first
implementation, and that we can expect changes in coming iOS releases. This
might go some way to explaining what you might initially think is a fairly
restrictive API:

#### 1. You cannot write code to run on the watch

When you add a watch target to an existing project, it creates both a watch app,
and an extension. The watch app itself cannot contain code - it only contains
image assets and a storyboard. This is what will be pushed to the watch. The
extension runs on an iPhone and interacts with the layout that you created in
the aforementioned storyboard.

This actually closely simulates the impression that you're running code on the
watch, but it's important to be aware of the effect that this "remote display"
will have on the functionality and experience you wish to implement.

#### 2. There are three "tasks" you can customize on a watch

In addition to creating a full watch-app, you can also create glances and
notifications. Notifications are exactly the same as existing notifications on
iOS - with the added ability to customize their appearance. A notification
appears full-screen and has different visualizations depending on the battery
level and the user's response. Users can interact with notifications in the same
way that they can with the new notification interactions introduced to iOS 8.

A glance is an entirely new concept to the watch. The user will be able to
swipe through a collection of glances, and as such they cannot interact with
them. They're designed to show you the most important info in a short amount of
time, i.e. a glance.

The app itself is a lot more heavyweight - allowing the user to fully interact
with the UI components. Don't be fooled into thinking it's just a little phone
app though - there are restrictions on what is achievable, along with the
completely different user interaction.

#### 3. The API is heavily focused around energy efficiency for the watch

Something that might seem strange to you when you start working with outlets in
storyboards, is that you cannot read properties from any of them - they are
write only. This is because the code is running on the iPhone, with the UI
update instructions being sent over bluetooth to the watch. This is an expensive
operation (in terms of power), so all unnecessary communications are
eliminated.

You should also note that setting properties on UI controls is not an
instantaneous procedure. Instead, the operations are batched up and pushed to
the watch in one go.

#### 4. You cannot get access to any of the watch's sensors

This is a little disappointing, since there are going to be some great ideas for
apps using these new sensors. I think that this is a side effect of the lack of
native apps on the watch in the initial release, and that some kind of
interaction with the sensors will arrive in due course. This means that your
watch apps aren't able to do anything that your iPhone apps couldn't do. In
fact, they're very much meant to augment your iPhone app, for quick access to
relevant summary info.

## Getting Started

Watch apps can't exist on their own - they are packaged up as part of an iPhone
app. This reinforces the notion that Apple Watch apps are designed to supplement
the functionality provided by an iPhone app, and are not meant to be standalone.

As such, creating a watch app requires that you have an existing iPhone app, to
which you can add a target:

![Add Target](assets/add_target.png)

There is a new section called __Apple Watch__, from which you can select __Watch
App__:

![Add Watch App](assets/add_watch_app.png)

The options screen allows you to specify whether you want a glance and
notification to be created alongside the app itself:

![Watch Creation](assets/watch_creation.png)

This will create two new targets - one for the watch app, and one for the
extension:

![Extension and App](assets/extension_and_app.png)

As mentioned before, the app itself runs on the phone, and doesn't currently
allow any custom code. It contains static assets - e.g. images and a storyboard
for the layout. The watch extension runs on the paired iPhone, and references
the storyboard that exists on the watch:

![Project Layout](assets/watch_project_layout.png)

In the rest of this section you'll learn about building a watch app, glances and
notifications.

### Watch App



### Glance

### Notifications 


## Conclusion
