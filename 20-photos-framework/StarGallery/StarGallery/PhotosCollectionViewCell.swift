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

class PhotosCollectionViewCell: UICollectionViewCell {
  
  var imageAsset: PHAsset? {
    didSet {
      self.imageManager?.requestImageForAsset(imageAsset!, targetSize: CGSize(width: 320, height: 320), contentMode: .AspectFill, options: nil) { image, info in
        self.photoImageView.image = image
      }
      starButton.alpha = imageAsset!.favorite ? 1.0 : 0.4
    }
  }
  
  var imageManager: PHImageManager?
    
  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var starButton: UIButton!
  
  @IBAction func handleStarButtonPressed(sender: AnyObject) {
    PHPhotoLibrary.sharedPhotoLibrary().performChanges({
      let changeRequest = PHAssetChangeRequest(forAsset: self.imageAsset)
      changeRequest.favorite = !self.imageAsset!.favorite
    }, completionHandler: nil)
  } 
}
