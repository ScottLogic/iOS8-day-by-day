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

import UIKit
import Photos

let reuseIdentifier = "Cell"

class PhotosCollectionViewController: UICollectionViewController {
  
  var images: PHFetchResult! = nil
  let imageManager = PHImageManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    images = PHAsset.fetchAssetsWithMediaType(.Image, options: nil)
  }
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */
  
  // MARK: UICollectionViewDataSource
  
  override func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
    return 1
  }
  
  
  override func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotosCollectionViewCell
    
    // Configure the cell
    self.imageManager.requestImageForAsset(images[indexPath.item] as PHAsset, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
      cell.photoImageView.image = image
    }
    
    return cell
  }
  
}
