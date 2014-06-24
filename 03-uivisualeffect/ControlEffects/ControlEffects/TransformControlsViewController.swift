//
//  TransformControlsViewController.swift
//  ControlEffects
//
//  Created by Sam Davies on 24/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit



class TransformControlsViewController: UIViewController {

  @IBOutlet var rotationSlider: UISlider
  @IBOutlet var xScaleSlider: UISlider
  @IBOutlet var yScaleSlider: UISlider
  @IBOutlet var xTranslationSlider: UISlider
  @IBOutlet var yTranslationSlider: UISlider
  
  var transformDelegate: TransformControlsDelegate?
  
  @IBAction func handleDismissButtonPressed(sender: UIButton) {
    dismissModalViewControllerAnimated(true)
  }
  
}

protocol TransformControlsDelegate {
  func transformDidChange(transform: CGAffineTransform, sender: AnyObject)
}


class MySwiftViewController: UIViewController  {
  // define the class
}

