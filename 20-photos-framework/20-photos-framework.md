# iOS8 Day-by-Day :: Day 20 :: Photos Framework

This post is part of a daily series of posts introducing the most exciting new
parts of iOS8 for developers - [#iOS8DayByDay](https://twitter.com/search?q=%23iOS8DayByDay).
To see the posts you've missed check out the [index page](http://shinobicontrols.com/iOS8DayByDay),
but have a read through the rest of this post first!

---

## Introduction




## Photo Library Outline

The library is comprised of model objects - the fundamental one being `PHAsset`,
which represents a single media asset. This could be a photo or a video, and has
properties including `pixelWidth`, `pixelHeight`, `creationDate`, 
`modificationDate` and `favorite`. All PhotoKit model objects are immutable,
so all of these properties are read-only.

These `PHAsset` objects are collected together into `PHAssetCollection` objects,
which are ordered collections of assets. These represent albums, smart albums
and moments and have properties such as `type`, `title`, `startDate` and
`endDate`.

Folders and years of moments are formed from `PHCollectionList`, which is again
and ordered collection.

The combination of these three classes allows the entire structure of the photo
library to be modeled. However, none of these give you access to anything other
than asset metadata. In order to request the 

## Querying For Models

## Requesting Assets

## Performing Model Updates

## Registering for Update Notifications

## Conclusion
