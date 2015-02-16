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

class RotationGestureRecognizer : UIPanGestureRecognizer {

  var touchAngle: CGFloat

  override init(target: AnyObject, action: Selector) {
    self.touchAngle = 0
    super.init(target: target, action: action)
    self.maximumNumberOfTouches = 1;
    self.minimumNumberOfTouches = 1;
  }

  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent!) {
    super.touchesBegan(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }

  override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent!) {
    super.touchesMoved(touches, withEvent: event)
    updateTouchAngleWithTouches(touches)
  }

  func updateTouchAngleWithTouches(touches: NSSet) {
    if let touch = touches.anyObject() as? UITouch {
      let touchPoint = touch.locationInView(self.view)
      self.touchAngle = self.calculateAngleToPoint(touchPoint)
    }
  }

  func calculateAngleToPoint(point: CGPoint) -> CGFloat {
    // Offset by the center
    let centerOffset = CGPointMake(point.x - CGRectGetMidX(self.view!.bounds),
      point.y - CGRectGetMidY(self.view!.bounds))
    return atan2(centerOffset.y, centerOffset.x)
  }
}

