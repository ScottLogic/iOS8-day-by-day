# iOS8 Day-by-Day :: Day 19 :: CoreImage Kernels

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction

CoreImage regularly pops up in the Day-by-Day series, but is underused in the 
wild, often because it is misunderstood. It provides highly optimized image
processing algorithms, in the form of filters and detectors, which can easily be
chained together in a light-weight processing pipeline.

One of the restrictions with CoreImage on iOS devices has always been that you
are restricted to using the provided filter kernels. This has meant that it is
incredibly difficult to use the GPU to perform any bespoke image processing.
However, iOS8 changes this - with the introduction of custom kernels in
CoreImage.

This post gives a brief introduction into the new custom kernel functionality -
with a couple of examples of creating your own filters. Custom kernels can be
quite complex - they are written in the GLSL language, and represent image
processing algorithms. This article will not attempt to describe either of these
in any detail, but instead discuss the mechanics of creating the kernels and
filters themselves.

The accompanying project is called __FilterBuilder__ and demonstrates building
two different types of CoreImage kernels - one using a color kernel, and one a
general kernel. The source code for this project is available in the repo on
github at [github.com/ShinobiControls/iOS8-day-by-day](http://github.com/ShinobiControls/iOS8-day-by-day).

## Filters and Kernels


## Custom Kernel Types

### Color Kernels


### Warp Kernels


## General Kernels


## Conclusion
