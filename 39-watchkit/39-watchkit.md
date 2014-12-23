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

The watch app itself is made up of two parts - the UI is created entirely in a
storyboard which exists on the watch itself, and the code that controls this
interface runs as an extension on the iPhone. This means that the code that is
used to power a watch app is subject to the same restrictions that extensions
are - e.g. it can't run any background tasks.

The storyboard in the watch app contains scenes for the three different
interfaces:

![Storyboard Overview](assets/storyboard_overview.png)

You can see that the scenes are sized appropriately for the watch. Since the
watch is so small, and low-powered, the layout doesn't use auto layout, but
instead relies on a system of groups and simple metrics. Size classes are also
not supported, but you can use similar techniques in IB to provide slightly
different layouts for the two watch sizes (38mm and 42mm):

![Screen Size Switcher](assets/screen_size_switcher.png)
![Screen Size Customisation](assets/create_screen_size_customisation.png)
![Screen Size Label Text](assets/screen_size_label_text.png)

As you look through the object library lots of it will look familiar from
traditional iOS apps. The appearance of the standard controls has been
configured to work well on a watch, and there is actually only a subset of the
controls you might expect. Some of the important differences are as follows:

- The only possibility for creating animations is through an animated image -
which can be a collection of frames named correctly.
- A table doesn't have a datasource, but instead works by adding cells
individually.
- Since updating UI is expensive, there are specialized label subclasses for
displaying a day and a timer. These autoupdate on the watch, and don't require
interaction with the watch app extension.
- Maps are not interactive, but are rendered on the phone and then pushed as an
image to the watch.
- A group has no visual appearance, but instead acts as a container for other
display elements. It arranges them in a line, either vertically or horizontally.
This is a very powerful control which allows you to construct a whole host of
different layouts.

Watch apps can have one of two forms of navigation - either page based or
hierarchy based. You cannot mix between these, and they are formed through
collections of `WKInterfaceController` objects, corresponding to the interface
controllers in the storyboard.

#### Watch extension code

A layout isn't useful on its own - it needs to be able to dynamically update to
show different information. Since the watch app cannot run any code, this
responsibility is left to the watch kit extension.

If you take a look inside __InterfaceController.swift__, you'll see that 
`InterfaceController` is a subclass of `WKInterfaceController`. This is roughly
equivalent to `UIViewController` in iOS, with the remote display magic built in.

A `WKInterfaceController` has four methods that form the core of its lifecycle:
- `init()` Standard for all objects. You can create data objects and things
here.
- `awakeWithContext(_:)` You can use the context object whenever you are
instantiating a new interface controller, to provide it with data or navigation
info. There is no restriction on the type of context you send. Should prepare
the interface controls.
- `willActivate()` Called just before the interface appears on screen - this is
roughly equivalent to `viewWillAppear()` in `UIViewController`
- `willDeactivate()` Called as the interface is disappearing. You can use it to
tidy up.

Interfacing with the layout in the watch app story board is achieved in the same
way that it is in an iPhone app - via IBOutlets and IBActions. You can drag from
IB into your `WKInterfaceController` as expected to create outlets and actions:

    @IBOutlet weak var quoteLabel: WKInterfaceLabel!
    @IBOutlet weak var quoteChangeTimer: WKInterfaceTimer!

    @IBAction func handleSkipButtonPressed() {
      ...
    }

Notice here the types of `@IBOutlet` properties - `WKInterfaceLabel` instead of
`UILabel`, and `WKInterfaceTimer`. These new types represent the difference in
functionality between iPhone and Apple Watch - where communicating with the
user interface is an expensive operation. These `WKInterface*` types are read
only - i.e. although you can set values, you cannot read them back. For example,
setting the text on a label looks like this:

    quoteLabel.setText(quotes[currentQuote])

`WKInterfaceTimer` is a specialized interface object that will count up or down
to or from a specified `NSDate`. Since this is also read only, you can interact
with it as follows:

    quoteChangeTimer.setDate(NSDate(timeIntervalSinceNow: quoteCycleTime))
    quoteChangeTimer.start()

Check the documentation for further details on these and other interface object
controls that are available as part of the Apple Watch SDK.

Some of the controls allow user interaction - such as buttons or switches. These
can be wired up to IBActions, in the way you'd expect. Note that you won't
receive a reference to the button in question - which therefore means you will
probably have to have a different method for each of the button actions.

#### Running A Watch App

You can run the watch app in a simulator by selecting the correct scheme from
the selection menu:

![Scheme Selector](assets/run_watch_app.png)

This will start the specified iOS simulator, and it should show your app in a
secondary display window representing the watch:

![Watch Window](assets/watch_window.png)

If it doesn't, or to switch between different watch sizes, you can use the
__External Displays__ list in the __Hardware__ menu:

![Hardware menu](assets/hardware_menu.png)

You can interact with this external display as you'd expect to be able to - so
you can put your new watch app through its paces even though you are not yet
able to buy an Apple Watch.

### Glance

When you created the watch target, you had the option of creating a glance. If
you chose to, then inside the watch storyboard, you'll be able to see a layout
for the glance:

![Glance Storyboard](assets/glance_storyboard.png)

You can use pretty much the same techniques for designing your glance layout as
you did for the full app - with one exception. Users cannot interact with a
glance - tapping a glance will open the associated watch app.

A glace interface has its counterpart class in the WatchKit extension, in the
same way that the watch app does. It is again a subclass of
`WKInterfaceController`, and therefore has the same lifecycle.

The simple example in the accompanying project just shows a random quote from
the NightWatch film:

    class GlanceController: WKInterfaceController {   
      @IBOutlet weak var quoteLabel: WKInterfaceLabel!
      let quoteGenerator = NightWatchQuotes()
      
      override func awakeWithContext(context: AnyObject!) {
        quoteLabel.setText(quoteGenerator.randomQuote())
      }
    }

You should use the `awakeWithContext(_:)` method to prepare and interface
objects, and the `willActivate()` method to do more time-critical operations
such as starting timers.

#### Running a Glance

Since the 'external display' approach of simulating an Apple Watch doesn't give
you a full simulator to play with, it's not immediately obvious how you can run
your glance. In fact, your watch target creates three different executables -
one for the app itself, one for the glance and one for the notification. The
scheme it creates defaults to using the watch app. To test the glance, you need
to create a new scheme which will run the glance executable.

Use the scheme selector to edit the current watch app scheme:

![Scheme Selector](assets/scheme_selector.png)

From this panel you can duplicate the watch app scheme, and call it something
like __Glance - WatchApp__. Then, using the __Run__ tab, you can change the 
__Executable__ to __Glance - NightWatch Watch App.app__:

![Select Executable](assets/select_executable.png)

This creates a new scheme, which you can select and run:

![Run Glance](assets/run_glance.png)

The resultant app now runs in the external display window, as expected:

![Glance](assets/glance.png)


### Notifications 

Out of everything possible use of a watch, you'd imagine that notifications
would be quite significant. It makes perfect sense to grab a quick look at your
wrist to check whether you need to deal with a new notification, rather than
digging around in your pocket for your phone.

You'll also be aware that iOS has a pretty comprehensive notifications system -
involving both remote and local notifications. It won't come as a surprise that
notifications on the Apple Watch 'plug-in' to the same system.

If you selected to create a notification when you added the watch target, then
you'll be able to see the notification layout in the storyboard:

![Notification Storyboard](assets/notification_storyboard.png)

This looks slightly different to the interface controllers you've seen for the
app and the glance - in that it appears to contain a segue. A notification can
appear in three different forms - the short notification just shows the app icon
and the title of the notification. If the user makes an appropriate gesture,
then the short notification will be replaced with a longer version, containing
more info. There are two forms of this long notification - static and dynamic.

The static version allows you to provide a static layout, which will have the
title of the notification inserted into a label. You have a lot more control
over the dynamic version - giving you access to the same level of control as you
had with the glance. You can specify that the system should only use the static
version, or you can provide a dynamic version. Note that the system might decide
to use the static version even if there is a dynamic version available if it is
low on power.

The dynamic version of the notification has a class backing it in the WatchKit
extension - a subclass of `WKUserNotificationInterfaceController`. This provides
some notification-specific methods in addition to the lifecycle methods from
`WKInterfaceController` - in the form of
`didReceiveLocalNotification(_:, withCompletionHandler:)` and 
`didReceiveRemoteNotification(_:, withCompletionHandler:)`. These can be used to
prepare the content for the dynamic layout.

#### Testing Notifications

In the same way as you did for the glance target, you'll need to create a new
scheme to associate with the notification executable. Notice this time that you
can select a payload JSON file:

![Selecting Payload Notification](assets/selecting_notification_payload.png)

This is a file that the template created, and can be found inside __Supporting
Files__:

![Payload Notification](assets/notification_payload.png)

This is just a JSON file which allows you to simulate what notification would
have been received to drive the notification's appearance:

    {
        "aps": {
            "alert": "You want to be human? Then act like a human.",
            "title": "New Quote!",
            "category": "myCategory"
        },
        
        "WatchKit Simulator Actions": [
            {
                "title": "First Button",
                "identifier": "firstButtonAction"
            }
        ],
        
        "customKey": "Use this file to define a testing payload for your notifications."
    }

You can provide the title and category as expected, and also provide the actions
that will be turned into buttons at the bottom of the notification.

Once you've set this up, you can run the notification scheme to see how your
notification executable behaves:

![Notification](assets/notification1.png)
![Notification](assets/notification2.png)

See the alert text appearing on the correct label and the introduction of an
alert action button as specified in the notification payload file. The dismiss
button is always provided by the system.

## Code sharing

Your watch app has to be part of an iPhone app, and representing the same kind
of functionality. This is likely to mean that you'll have code that you'd like
to use both in the phone app and in the WatchKit extension. There are a few
options for tackling this problem:

- __Copy/Paste__ Yeah, we know it's the root of all evil, but you might find it
easier to start with this approach and then refactor your code to something
nicer later on.
- __Framework__ iOS8 introduced the ability to create dynamic frameworks - i.e.
places where shared code and functionality can reside, and be accessed from
other frameworks (i.e. apps and extensions) from within the same application
bundle. This is actually the approach taken in __NightWatch__. The
__NightWatchData__ framework provides a __NightWatchQuotes__ class that can then
be used from both the WatchKit extension and the iPhone app.
- __Host in iPhone app__ It's possible for the WatchKit extension to request
that the iPhone app is opened, and then for the iPhone app to reply with some
kind of data. This has multiple uses - one of them is for an action on the watch
to trigger something on the phone, or also for the WatchKit extension to request
that the iPhone app perform some kind of task. This might seem a little strange
at first, but remember that there are restrictions on what an extension is
allowed to do. There are no such restrictions on the container app, and
therefore you could load it up in the background and use this inaccessible
functionality. One example of this could be performing a background network
request.

These techniques are likely to evolve as the SDK does, but it's good to know
that there are alternatives to copy-paste right from the beginning.


## Conclusion

The Apple Watch looks to be a really exciting new addition to Apple's hardware
range. I'm really interested to see how well it gets adopted. How many people
who don't currently wear a watch will suddenly need one?

This first release of WatchKit seems to be really well thought out. You don't
get all the functionality you're used to from UIKit and wider iOS, but there's a
lot there to get started with. You can create really quite powerful apps without
a huge amount of difficulty. That being said, I'm looking forward to seeing how
this SDK evolves. It'll be great to have access to the new sensors, and to see
what level of access we, as developers, are allowed by Apple to the rest of the
device. It's great to see that the entire API design has held power efficiency,
and hence user experience, at the highest importance.

As ever, the code for today's post is available on the ShinobiControls github,
at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
I'd very much value your thoughts, opinions and feedback - hit me up on twitter
at [@iwantmyrealname](https://twitter.com/iwantmyrealname).

I'm expecting this to be the last entry in the iOS8 Day-by-Day blog series. I
hope you've found them useful, and look forward to the compilation book that
will be released early next year!

cheers

sam
x





