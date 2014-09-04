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
import QuartzCore

class ViewController: UIViewController {

  @IBOutlet var bgImageView: UIImageView!
  
  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    let transitionToWide = size.width > size.height
    let image = UIImage(named: transitionToWide ? "bg_wide" : "bg_tall")
    
    coordinator.animateAlongsideTransition({
      context in
      // Create a transition and match the context's duration
      let transition = CATransition()
      transition.duration = context.transitionDuration()
      
      // Make it fade
      transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
      transition.type = kCATransitionFade
      self.bgImageView.layer.addAnimation(transition, forKey: "Fade")
      
      // Set the new image
      self.bgImageView.image = image
      }, completion: nil)
  }
}

