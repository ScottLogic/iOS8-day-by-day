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
  
  var xCG: CGFloat {
    return CGFloat(x)
  }
  var yCG: CGFloat {
    return CGFloat(y)
  }
}

class TransformControlsViewController: UIViewController {

  @IBOutlet var containerView: UIView
  @IBOutlet var rotationSlider: UISlider
  @IBOutlet var xScaleSlider: UISlider
  @IBOutlet var yScaleSlider: UISlider
  @IBOutlet var xTranslationSlider: UISlider
  @IBOutlet var yTranslationSlider: UISlider
  
  var transformDelegate: TransformControlsDelegate?
  var currentTransform: CGAffineTransform?
  
  var backgroundView: UIVisualEffectView?
  
  override func viewDidLoad() {
    if(currentTransform) {
      applyTransformToSliders(currentTransform!)
    }
    
    backgroundView = prepareVisualEffectView()
    view.addSubview(backgroundView)
    
    applyEqualSizeConstraints(view, v2: backgroundView!)
    
    view.backgroundColor = UIColor(white: 1, alpha: 0)
    
  }
  
  
  func prepareVisualEffectView() -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let effectView = UIVisualEffectView(effect: blurEffect)
    effectView.contentView.backgroundColor = UIColor(white: 0.7, alpha: 0)
    containerView.removeFromSuperview()
    effectView.contentView.addSubview(containerView)
    containerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    effectView.setTranslatesAutoresizingMaskIntoConstraints(false)
    applyEqualSizeConstraints(effectView.contentView, v2: containerView)
    
    return effectView
  }
  
  func applyEqualSizeConstraints(v1: UIView, v2: UIView) {
    v1.addConstraint(NSLayoutConstraint(item: v1, attribute: .CenterX, relatedBy: .Equal, toItem: v2, attribute: .CenterX, multiplier: 1, constant: 0))
    v1.addConstraint(NSLayoutConstraint(item: v1, attribute: .CenterY, relatedBy: .Equal, toItem: v2, attribute: .CenterY, multiplier: 1, constant: 0))
    v1.addConstraint(NSLayoutConstraint(item: v1, attribute: .Width, relatedBy: .Equal, toItem: v2, attribute: .Width, multiplier: 1, constant: 0))
    v1.addConstraint(NSLayoutConstraint(item: v1, attribute: .Height, relatedBy: .Equal, toItem: v2, attribute: .Height, multiplier: 1, constant: 0))
  }
  

  
  @IBAction func handleSliderValueChanged(sender: UISlider) {
    let transform = transformFromSliders()
    currentTransform = transform
    transformDelegate?.transformDidChange(transform, sender: self)
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
  
  func applyTransformToSliders(transform: CGAffineTransform) {
    let decomposition = decomposeAffineTransform(transform)
    rotationSlider.value = decomposition.rotation
    xScaleSlider.value = decomposition.scale.x
    yScaleSlider.value = decomposition.scale.y
    xTranslationSlider.value = decomposition.translation.x
    yTranslationSlider.value = decomposition.translation.y
  }
  
  func constructTransform(rotation: Float, scale: Vect2D, translation: Vect2D) -> CGAffineTransform {
    let rotnTransform = CGAffineTransformMakeRotation(CGFloat(rotation))
    let scaleTransform = CGAffineTransformScale(rotnTransform, scale.xCG, scale.yCG)
    let translationTransform = CGAffineTransformTranslate(scaleTransform, translation.xCG, translation.yCG)
    return translationTransform
  }
  
  
  func decomposeAffineTransform(transform: CGAffineTransform) -> (rotation: Float, scale: Vect2D, translation: Vect2D) {
    // This requires a specific ordering (and no skewing). It matches the constructTransform method
    
    // Translation first
    let translation = Vect2D(x: Float(transform.tx), y: Float(transform.ty))
    
    // Then scale
    let scaleX = sqrt(Double(transform.a * transform.a + transform.c * transform.c))
    let scaleY = sqrt(Double(transform.b * transform.b + transform.d * transform.d))
    let scale = Vect2D(x: Float(scaleX), y: Float(scaleY))
    
    // And rotation
    let rotation = Float(atan2(Double(transform.b), Double(transform.a)))
    
    return (rotation, scale, translation)
  }
}

