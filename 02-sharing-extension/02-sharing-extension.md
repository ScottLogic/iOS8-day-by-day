# iOS8 Day-by-Day :: Day 2 :: Sharing Extension

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the introduction page,
but have a read through the rest of this post first!

---

## Introduction

A __huge__ new feature in iOS8 is the introduction of support for extensions.
These are areas in which developers can enhance the operating system, including
both 3rd-party apps and Apple-provided apps, with their own features and
functionality. There are 6 extensions applicable to iOS:

- Today screen widgets
- Share extensions
- Actions
- Photo editing
- Storage providers
- Custom keyboards

We'll cover some of these in later editions of iOS8 Day-by-Day, but today's article
is focussed on sharing extensions.

Sharing extensions give you, the developer of an app, to show an icon on the
common share-sheet, and then to handle the sharing of the content the user has
requested. This means that you can supplement the list of possibilities present
in the OS (e.g. Twitter, Flickr, Sina Weibo).

A word of warning: this topic is not an easy one. From the mere nature of an
extension it is pretty complex. The article will take you through some of the
most common use cases, but be aware that you can pretty much build your own
visual appearance. Apple has some excellent resources in this area, so it's
worth having a read through them if you get stuck with anything.

The sample app for today's post is called "ShareAlike", and demonstrates building
a sharing extension which allows sharing an image and some text. The code is
available on Github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).


## Creating a share extension

Extensions are compiled binaries which have to be contained within an app - it's
not possible to add an extension to the system without an accompanying app.
Xcode has a template for adding an extension to an existing app - it'll set up
a new module within your project and provide you with the required files to get
started.

The major part of a sharing extension is its visual appearance, and as such
you're provided with a subclass of `SLComposeServiceViewController` and a
storyboard. The default appearance of `SLComposeServiceViewController` gives you
a lot of sensible behaviour (including a character count, image display, text
entry, post and cancel buttons) and fits in with the iOS UI. In this example
we're going to stick with this default behaviour.

In addition to the standard `UIViewController` methods, `SLComposeServiceViewController`
has some methods and properties associated with the lifecycle of a share-sheet
composition view:

- `presentationAnimationDidFinish()` this provides a great hook to perform any
heavy-lifting tasks. We'll use this to extract the image to share.
- `contentText` a string which represents what the user has typed into the
composer
- `didSelectPost()` called when the __Post__ button is tapped. The point to kick
off the upload task.
- `didSelectCancel()` called when the __Cancel__ button is tapped.
- `isContentValid()` called every time the content in the compose view changes.
- `charactersRemaining` is a number which appears on the compose sheet. When
negative its appearance becomes red

Simply adding an extension to your app's project will allow it to be selected when
a user requests to share something. We'll take a look at implementing some useful
functionality soon, but first, let's learn a little about how to build, run
and debug

### Building, running and debugging

In theory, you should be able to select the scheme associated with the extension
and hit run. You'll then be asked which host app you'd like to debug it in, and
you'll be away. This experience can be more than a little flakey. The only apps
it is possible to choose (as of Xcode 6b3) are your own development apps - not
system apps. This seems a little strange - the perfect app for testing sharing
would be the photos app.

However, the following approach seems to be reliable:

1. Either use your extension's host app, or add a new app to the same project
which has easily available content for sharing. In the sample project, the
__ShareAlike__ host app has an image and a share button which will trigger a
standard UI share sheet:

    @IBAction func handleShareSampleTapped(sender: AnyObject) {
      shareContent(sharingText: "Highland Cow", sharingImage: sharingContentImageView.image)
    }

    // Utility methods
    func shareContent(#sharingText: String?, sharingImage: UIImage?) {
      var itemsToShare = [AnyObject]()

      if let text = sharingText {
        itemsToShare.append(text)
      }
      if let image = sharingImage {
        itemsToShare.append(image)
      }

      let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
      presentViewController(activityViewController, animated: true, completion: nil)
    }

PICTURE OF APP

2. Develop your extension
3. To debug and or test, run the scheme associated with your app. Then when you
hit share then the debugger will automatically attach to the process associated
with the extension.
4. You can use the sharing extension from other apps on the simulator, but you
won't have debuggin access. It's good to get it to a working state and then test
it within the Photos app.


### Specifying what can be shared

In the same way that the settings associated with an app are contained within
an __Info.plist__ file, there is an equivalent file for the extension module.
One of the things you can control is the name of the extension which appears
under the icon in the share sheet.

The name is defined by the __Bundle display name__ (`CFBundleDisplayName`):

PICTURE

You can also use the __Info.plist__ file to define under which circumstances
your share extension is applicable - e.g. can it handle videos? There is a very
powerful string-predicate language you can use here, but for 99% of cases, using
a dictionary will suffice.

Inside the `NSExtension` dictionary, there is a `NSExtensionAttributes` dictionary,
one of the values of which is `NSExtenionActivationRule`. This can be a boolean,
a string or a dictionary. The following shows a dictionary with settings which
will enable a single image to be shared, disables videos, files and URLs

IMAGE HERE

The different dictionary keys are pretty self-explanatory, and the result can be
seen here; selecting one image to share shows __ShareAlike__ as an option, whereas
two images does not:

TWO IMAGES


## Uploading from within an extension


### Extracting an image to upload


### Creating a shared container



## Conclusion

Sharing extensions are just one of the extensions available to developers in iOS8,
and represents Apple opening up the operating system in a way they've been
asked to do for a while. Interestingly, it's done in a way that has prioritized
security and privacy, arguably at a small cost of customisability.

Building sharing extensions is far from trivial, and along the route there are
many things that can trip you up. However, if it's applicable to you and your app
then it's definitely worth investing the time in. The API is good, and the gain
to your users could be huge.

The code for this project is available on github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
In order to get the uploading working, you will need to ensure that you've got
a shared container configured correctly, although the project file should do
most of that for you.

Look out for future articles in the iOS8 Day-by-Day series which will investigate
some of the other new extensions available in iOS8.

Any questions / comments / complaints then drop me a tweet - I'm
[@iwantmyrealname](https://twitter.com/iwantmyrealname).


sam
