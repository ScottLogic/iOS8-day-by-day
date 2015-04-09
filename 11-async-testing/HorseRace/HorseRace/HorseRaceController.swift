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

import Foundation
import UIKit

public struct Horse {
  public let horseView: UIView
  private let startConstraint: NSLayoutConstraint
  private let finishConstraint: NSLayoutConstraint?
  
  init(horseView: UIView, startConstraint: NSLayoutConstraint, finishLineOffset:CGFloat) {
    self.horseView = horseView
    self.startConstraint = startConstraint
    self.finishConstraint = NSLayoutConstraint(item: horseView, attribute: .Right, relatedBy: .Equal, toItem: horseView.superview, attribute: .Right, multiplier: 1, constant: finishLineOffset)
  }
}


public class TwoHorseRaceController {
  
  let horses: [Horse]
  
  init(horses: [Horse]) {
    self.horses = horses
    srand48(time(nil));
  }
  
  public func reset() {
    for horse in horses {
      updateContraintsToStartOfRace(horse)
      horse.horseView.layoutIfNeeded()
    }
  }
  
  public func startRace(maxDuration: NSTimeInterval, horseCrossedLineCallback: ((Horse) -> Void)?) {

    for horse in horses {
      // Generate a random time
      let duration = maxDuration / 2.0 * (1 + drand48())
      
      // Perform the animation
      UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseIn,
        animations: {
          self.updateConstraintsToEndOfRace(horse)
          horse.horseView.layoutIfNeeded()
        }, completion: { _ in
          if let horseCrossedLineCallback = horseCrossedLineCallback {
            horseCrossedLineCallback(horse)
          }
        })
    }
  }
  
  func updateConstraintsToEndOfRace(horse: Horse) {
    horse.startConstraint.active = false
    horse.finishConstraint?.active = true
  }
  
  func updateContraintsToStartOfRace(horse: Horse) {
    horse.finishConstraint?.active = false
    horse.startConstraint.active = true
  }
  
  
  public func someKindOfAsyncMethod(completionHandler: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      sleep(3)
      dispatch_async(dispatch_get_main_queue(), {
        completionHandler()})
      })
  }
}
