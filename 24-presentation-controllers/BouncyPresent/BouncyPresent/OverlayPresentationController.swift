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

class OverlayPresentationController: UIPresentationController {
   let dimmingView = UIView()
  
  override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
    super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
  }
  
  override func presentationTransitionWillBegin() {
    dimmingView.frame = containerView.bounds
    dimmingView.alpha = 0.0
    containerView.insertSubview(dimmingView, atIndex: 0)
    
    presentedViewController.transitionCoordinator().animateAlongsideTransition({
      context in
      self.dimmingView.alpha = 1.0
    }, completion: nil)
  }
  
  override func dismissalTransitionWillBegin() {
    presentedViewController.transitionCoordinator().animateAlongsideTransition({
      context in
      self.dimmingView.alpha = 0.0
    }, completion: {
      context in
      self.dimmingView.removeFromSuperview()
    })
  }
  
  override func frameOfPresentedViewInContainerView() -> CGRect {
    return containerView.bounds.rectByInsetting(dx: 30, dy: 30)
  }
  
  override func containerViewWillLayoutSubviews() {
    dimmingView.frame = containerView.bounds
    presentedView().frame = frameOfPresentedViewInContainerView()
  }
}
