//
//  TransformControlsViewController.swift
//  ControlEffects
//
//  Created by Sam Davies on 24/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

protocol TransformControlsDelegate {
  func transformDidChange(transform: CGAffineTransform, sender: AnyObject)
}

struct Vect2D {
  var x: Float
  var y: Float
}

class TransformControlsViewController: UIViewController {

  @IBOutlet var rotationSlider: UISlider
  @IBOutlet var xScaleSlider: UISlider
  @IBOutlet var yScaleSlider: UISlider
  @IBOutlet var xTranslationSlider: UISlider
  @IBOutlet var yTranslationSlider: UISlider
  
  var transformDelegate: TransformControlsDelegate?
  
  @IBAction func handleSliderValueChanged(sender: UISlider) {
    transformDelegate?.transformDidChange(transformFromSliders(), sender: self)
  }
  
  
  @IBAction func handleDismissButtonPressed(sender: UIButton) {
    dismissModalViewControllerAnimated(true)
  }
  
  func transformFromSliders() -> CGAffineTransform
  {
    let scale = Vect2D(x: xScaleSlider.value, y: yScaleSlider.value)
    let translation = Vect2D(x: xTranslationSlider.value, y: yTranslationSlider.value)
    
    return constructTransform(rotationSlider.value, scale: scale, translation: translation)
  }
  
  func constructTransform(rotation: Float, scale: Vect2D, translation: Vect2D) -> CGAffineTransform {
    let rotnTransform = CGAffineTransformMakeRotation(CGFloat(rotation))
    let scaleTransform = CGAffineTransformScale(rotnTransform, CGFloat(scale.x), CGFloat(scale.y))
    let translationTransform = CGAffineTransformTranslate(scaleTransform, CGFloat(translation.x), CGFloat(translation.y))
    return translationTransform
  }
  
}

