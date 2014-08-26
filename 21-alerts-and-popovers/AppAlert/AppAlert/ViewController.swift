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

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  @IBAction func handlePopoverPressed(sender: AnyObject) {
    let popoverVC = storyboard.instantiateViewControllerWithIdentifier("codePopover") as UIViewController
    popoverVC.modalPresentationStyle = .Popover
    let popoverController = popoverVC.popoverPresentationController
    popoverController.sourceView = sender as UIView
    popoverController.permittedArrowDirections = .Any
    popoverController.delegate = self
    presentViewController(popoverVC, animated: true, completion: nil)
  }
  
  @IBAction func handleAlertPressed(sender: AnyObject) {
  }
  
  @IBAction func handleActionSheetPressed(sender: AnyObject) {
  }
  
  
  
  // MARK: - UIPopoverPresentationControllerDelegate
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
    return .FullScreen
  }
  
  func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController! {
    return UINavigationController(rootViewController: controller.presentedViewController)
  }
}

