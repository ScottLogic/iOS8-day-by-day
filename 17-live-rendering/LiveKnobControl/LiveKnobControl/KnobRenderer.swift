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

class KnobRenderer {
  let trackLayer = CAShapeLayer()
  let pointerLayer = CAShapeLayer()

  var pointerLength:CGFloat = 0.0 {
  didSet {
    self.updateTrackShape()
    self.updatePointerShape()
  }
  }

  var lineWidth:CGFloat = 0.0 {
  didSet {
    self.trackLayer.lineWidth = lineWidth
    self.pointerLayer.lineWidth = lineWidth
    self.updateTrackShape()
    self.updatePointerShape()
  }
  }

  var startAngle:CGFloat = 0.0 {
  didSet {
    self.updateTrackShape()
  }
  }

  var endAngle:CGFloat = 0.0 {
  didSet {
    self.updateTrackShape()
  }
  }

  var color:UIColor = UIColor.clearColor() {
  didSet {
    self.trackLayer.strokeColor = color.CGColor
    self.pointerLayer.strokeColor = color.CGColor
  }
  }

  var _primitivePointerAngle:CGFloat = 0.0
  var pointerAngle:CGFloat {
  get { return self._primitivePointerAngle }
  set { self.setPointerAngle(newValue, animated: false) }
  }

  init() {
    self.trackLayer.fillColor = UIColor.clearColor().CGColor
    self.pointerLayer.fillColor = UIColor.clearColor().CGColor
  }

  func updateTrackShape() {
    let center = CGPointMake(
      CGRectGetWidth(self.trackLayer.bounds)/2.0,
      CGRectGetHeight(self.trackLayer.bounds)/2)

    let offset = max(self.pointerLength, self.lineWidth / 2.0)

    let radius = min(CGRectGetHeight(self.trackLayer.bounds),
      CGRectGetWidth(self.trackLayer.bounds)) / 2.0 - offset;

    let ring = UIBezierPath(arcCenter:center,
      radius:radius,
      startAngle:self.startAngle,
      endAngle:self.endAngle,
      clockwise:true)
    self.trackLayer.path = ring.CGPath
  }

  func updatePointerShape() {
    let pointer = UIBezierPath()
    pointer.moveToPoint(CGPointMake(CGRectGetWidth(self.pointerLayer.bounds) - self.pointerLength - self.lineWidth/2.0,
      CGRectGetHeight(self.pointerLayer.bounds) / 2.0))
    pointer.addLineToPoint(CGPointMake(CGRectGetWidth(self.pointerLayer.bounds),
      CGRectGetHeight(self.pointerLayer.bounds) / 2.0))
    self.pointerLayer.path = pointer.CGPath
  }

  func updateWithBounds(bounds: CGRect) {
    self.trackLayer.bounds = bounds
    self.trackLayer.position = CGPointMake(CGRectGetWidth(bounds)/2.0, CGRectGetHeight(bounds)/2.0)
    self.updateTrackShape()

    self.pointerLayer.bounds = trackLayer.bounds
    self.pointerLayer.position = trackLayer.position
    self.updatePointerShape()
  }

  func setPointerAngle(newValue:CGFloat, animated:Bool) {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

    self.pointerLayer.transform = CATransform3DMakeRotation(newValue, 0, 0, 1)

    if(animated) {
      // Provide an animation
      // Key-frame animation to ensure rotates in correct direction
      let midAngle = (max(self.pointerAngle, self._primitivePointerAngle) -
        min(self.pointerAngle, self._primitivePointerAngle) ) / 2.0 +
        min(self.pointerAngle, self._primitivePointerAngle)
      let animation = CAKeyframeAnimation(keyPath:"transform.rotation.z")

      animation.duration = 0.4
      animation.values = [self._primitivePointerAngle, midAngle, newValue]
      animation.keyTimes = [0, 0.3, 1.0]
      animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
      self.pointerLayer.addAnimation(animation, forKey: "rotate")
    }

    self._primitivePointerAngle = newValue

    CATransaction.commit()
  }
}