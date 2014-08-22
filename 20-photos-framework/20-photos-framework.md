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
than asset metadata. `PHImageManager` is used to request the image associated
with a given `PHAsset`. This handles any network requests, rescaling and can
even do caching. It can provide a placeholder image whilst the required quality
is requested from the network.

## Querying For Models

Each of the model classes has class methods associated with it to query the
photo library - for example `PHAsset` has `fetchAssetsWithMediaType()`. All the
model fetch methods are synchronous, and return an instance of `PHFetchResult`.
The following will create a fetch result containing all the images:

    let images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)

`PHFetchResult` has an API which looks very like `NSArray`, so you can iterate
through the results, access results by index, and count the total number of
items in the fetch result. Importantly, the items are lazy-loaded from the store
in batches - i.e. the results aren't all loaded in to memory at call-time, but
are instead loaded when required. This reduces the memory footprint on something
that could be a result set.

In the accompanying project, __StarGallery__, there is a collection view which
displays all the images in the photo library. The asset models are loaded using
the code snippet above in `viewDidLoad()`. As mentioned before, these objects
are just the models which represent the assets in the photo library - they don't
include the image itself. In the next section you'll learn how to request the
image.

## Requesting Assets

If you're going to use the photo library, then it's likely that you'll want to
get hold of the images themselves - not just the asset models. PhotoKit makes
this really easy, via the `PHImageManager` class. Once you've created an
instance, then you can request an image with the `requestImageForAsset()`
method, as follows:

    self.imageManager?.requestImageForAsset(imageAsset!,
                                  targetSize: CGSize(width: 320, height: 320), 
                                  contentMode: .AspectFill, options: nil) {
      image, info in
      self.photoImageView.image = image
    }

In addition to providing the `PFAsset` which represents the image, you also need
to provide a size and a content mode. This combination means that the image
manager will rescale the image appropriately and return it to you. This method
is asynchronous - with the image returned to the closure above. Since this is
usually going to be used to update the UI, the framework will invoke this
closure on the main queue. The closure might well be called more than once - if
the required image quality isn't immediately available then a placeholder may
well be provided until the request can be fulfilled (e.g. returned from the
network).

In addition the base `PHImageManager` class, PhotoKit also includes a 
`PHCachingImageManager`, which caches images, allowing preheating which results
in better scrolling performance. In order to use this you need to be able to
tell the image manager which assets it should start caching (i.e. load up) and
which ones it no longer needs to cache. Note that the cache works on specific
image sizes - so you can cache the same asset multiple times (at different sizes).

The following method is part of an `ImageCacheController` class in
__StarGallery__:

    func updateVisibleCells(visibleCells: [NSIndexPath]) {
      let updatedCache = NSMutableIndexSet()
      for path in visibleCells {
        updatedCache.addIndex(path.item)
      }
      let minCache = max(0, updatedCache.firstIndex - cachePreheatSize)
      let maxCache = min(images.count - 1, updatedCache.lastIndex + cachePreheatSize)
      updatedCache.addIndexesInRange(NSMakeRange(minCache, maxCache - minCache + 1))
      
      // Which indices can be chucked?
      self.cachedIndices.enumerateIndexesUsingBlock {
        index, _ in
        if !updatedCache.containsIndex(index) {
          let asset: AnyObject! = self.images[index]
          self.imageCache.stopCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
          println("Stopping caching image \(index)")
        }
      }
      
      // And which are new?
      updatedCache.enumerateIndexesUsingBlock {
        index, _ in
        if !self.cachedIndices.containsIndex(index) {
          let asset: AnyObject! = self.images[index]
          self.imageCache.startCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
          println("Starting caching image \(index)")
        }
      }
      cachedIndices = NSIndexSet(indexSet: updatedCache)
    }

As the user scrolls, this method is called with an array of `NSIndexPath`
objects for the visible cells. This method determines whether the cache needs
updating, based on the visible cells, and the `cachePreheatSize`. It then
updates the caching image manager with the `stopCachingImagesForAssets()` and 
`startCachingImagesForAssets()` methods.

Note that obtaining the image from a caching image manager is exactly the same
as the base `PHImageManager` - and it will obtain the image even if it doesn't
exist in the cache.

## Performing Model Updates

## Registering for Update Notifications

## Conclusion
