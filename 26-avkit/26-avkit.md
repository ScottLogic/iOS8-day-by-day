# iOS8 Day-by-Day :: Day 26 :: AVKit

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

If you want to play a video in iOS then you've traditionally been presented with
two choices. If you want simple playback with framework provided UI then you
could use `MPMoviePlayerViewController`, or if you require fine-grain control of
the underlying `AVFoundation` pipeline then you could use an `AVPlayer`,
rendered through an `AVPlayerLayer`. The problem with these approaches is that
the former doesn't give you much control over the playback process, whereas the
latter requires that you create your own UI.

AVKit is new to iOS8 and pulls both scenarios into a common pipeline.
`AVPlayerViewController` effectively deprecates `MPMovePlayerViewController`,
and sits on top of AVFoundation. It provides contextual video playback UI that
matches that of the OS, and plays any `AVPlayer` object from AVFoundation.

In today's post you'll discover how easy it is to integrate AVKit into your app,
and see some of the cool new things you can do. The app which accompanies the
article is a simple video player, which uses the Photos framework to find videos
in the user's library, and then plays them using AVKit. You can download the
source code from the ShinobiControls github at
[github.com/ShinobiControls/iOS8-day-by-day](https://github.com/ShinobiControls/iOS8-day-by-day).
If you're using the simulator then you can add some videos to the library by
dragging them in from the finder, and then selecting "save" from the sharing
menu.


## Conclusion


