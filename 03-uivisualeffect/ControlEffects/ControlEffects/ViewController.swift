//
//  ViewController.swift
//  ControlEffects
//
//  Created by Sam Davies on 24/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TransformControlsDelegate {
    
  @IBOutlet var imageView: UIImageView
                            
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  // <TransformControlsDelegate>
  func transformDidChange(transform: CGAffineTransform, sender: AnyObject) {
    // Update the transform applied to the image view
    imageView.transform = transform
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    if segue.identifier? == "showTransformController" {
      if let transformController = segue.destinationViewController as? TransformControlsViewController {
        transformController.transformDelegate = self
        transformController.currentTransform = imageView.transform
      }
    }
  }

}

