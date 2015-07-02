//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Photos

/* NOTE: This only works with a single-section data set */

class ImageCacheController {
  
  private var cachedIndices = NSIndexSet()
  var cachePreheatSize: Int
  var imageCache: PHCachingImageManager
  var images: PHFetchResult
  var targetSize = CGSize(width: 320, height: 320)
  var contentMode = PHImageContentMode.AspectFill
  
  init(imageManager: PHCachingImageManager, images: PHFetchResult, preheatSize: Int = 1) {
    self.cachePreheatSize = preheatSize
    self.imageCache = imageManager
    self.images = images
  }
  
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
        let asset: PHAsset! = self.images[index] as! PHAsset
        self.imageCache.stopCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
        print("Stopping caching image \(index)")
      }
    }
    
    // And which are new?
    updatedCache.enumerateIndexesUsingBlock {
      index, _ in
      if !self.cachedIndices.containsIndex(index) {
        let asset: PHAsset! = self.images[index] as! PHAsset
        self.imageCache.startCachingImagesForAssets([asset], targetSize: self.targetSize, contentMode: self.contentMode, options: nil)
        print("Starting caching image \(index)")
      }
    }
    cachedIndices = NSIndexSet(indexSet: updatedCache)
  }
  
}