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
import AVKit

class VideoDetailViewController: UIViewController {
  
  let imageManager = PHImageManager.defaultManager()
  var player: AVPlayer? {
    didSet {
      if let avpVC = self.childViewControllers.first as? AVPlayerViewController {
        dispatch_async(dispatch_get_main_queue()) {
          avpVC.player = self.player
        }
      }
    }
  }
  var videoAsset: PHAsset? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureView()
  }
  
  func configureView() {
    if let videoAsset = videoAsset {
      imageManager?.requestPlayerItemForVideo(videoAsset, options: nil, resultHandler: {
        playerItem, info in
        self.player = AVPlayer(playerItem: playerItem)
      })
    }
  }
  
}
