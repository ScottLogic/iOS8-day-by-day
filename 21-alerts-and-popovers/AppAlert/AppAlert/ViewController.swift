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

  @IBAction func handlePopoverPressed(sender: UIView) {
    let popoverVC = storyboard?.instantiateViewControllerWithIdentifier("codePopover") as! UIViewController
    popoverVC.modalPresentationStyle = .Popover
    if let popoverController = popoverVC.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = sender.bounds
      popoverController.permittedArrowDirections = .Any
      popoverController.delegate = self
    }
    presentViewController(popoverVC, animated: true, completion: nil)
  }
  
  @IBAction func handleAlertPressed(sender: AnyObject) {
    let alert = UIAlertController(title: "Alert", message: "Using the alert controller", preferredStyle: .Alert)
    
    let dismissHandler = {
      (action: UIAlertAction!) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: dismissHandler))
    alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: dismissHandler))
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: dismissHandler))
    alert.addTextFieldWithConfigurationHandler { textField in
      textField.placeholder = "Sample text field"
    }
    presentViewController(alert, animated: true, completion: nil)
  }
  
  @IBAction func handleActionSheetPressed(sender: UIView) {
    let actionSheet = UIAlertController(title: "Action Sheet", message: "Using the alert controller", preferredStyle: .ActionSheet)
    if let presentationController = actionSheet.popoverPresentationController {
      presentationController.sourceView = sender
      presentationController.sourceRect = sender.bounds
    }
    
    let dismissHandler = {
      (action: UIAlertAction!) in
      self.dismissViewControllerAnimated(true, completion: nil)
    }
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: dismissHandler))
    actionSheet.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: dismissHandler))
    actionSheet.addAction(UIAlertAction(title: "OK", style: .Default, handler: dismissHandler))
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  
  
  // MARK: - UIPopoverPresentationControllerDelegate
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .FullScreen
  }
  
  func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    return UINavigationController(rootViewController: controller.presentedViewController)
  }
}

