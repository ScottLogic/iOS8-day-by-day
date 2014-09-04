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

class BouncyViewControllerAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.8
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    if let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) {
      let centre = presentedView.center
      presentedView.center = CGPointMake(centre.x, -presentedView.bounds.size.height)
      
      transitionContext.containerView().addSubview(presentedView)
      
      UIView.animateWithDuration(self.transitionDuration(transitionContext),
        delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: nil,
        animations: {
          presentedView.center = centre
        }, completion: {
          _ in
          transitionContext.completeTransition(true)
      })
    }
  }
}
