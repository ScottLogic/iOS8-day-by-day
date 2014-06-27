//
//  HorseRaceController.swift
//  HorseRace
//
//  Created by Sam Davies on 27/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import Foundation
import UIKit

struct Horse {
  var horseView: UIView
  var startConstraint: NSLayoutConstraint
  var finishConstraint: NSLayoutConstraint?
  
  init(horseView: UIView, startConstraint: NSLayoutConstraint, finishLineOffset:CGFloat) {
    self.horseView = horseView
    self.startConstraint = startConstraint
    self.finishConstraint = NSLayoutConstraint(item: horseView, attribute: .Right, relatedBy: .Equal, toItem: horseView.superview, attribute: .Right, multiplier: 1, constant: finishLineOffset)
  }
}


class TwoHorseRaceController {
  
  var horses: Horse[]
  
  init(horses: Horse[]) {
    self.horses = horses
    srand48(time(nil));
  }
  
  func reset() {
    for horse in horses {
      updateContraintsToStartOfRace(horse)
      horse.horseView.layoutIfNeeded()
    }
  }
  
  func startRace(maxDuration: NSTimeInterval, horseCrossedLineCallback: ((Horse) -> Void)?) {

    for horse in horses {
      // Generate a random time
      let duration = maxDuration / 2.0 * (1 + drand48())
      
      // Perform the animation
      UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseIn,
        animations: {
          self.updateConstraintsToEndOfRace(horse)
          horse.horseView.layoutIfNeeded()
        }, completion: { _ in
          if let callback = horseCrossedLineCallback? {
            callback(horse)
          }
        })
    }
  }
  
  func updateConstraintsToEndOfRace(horse: Horse) {
    horse.horseView.superview.removeConstraint(horse.startConstraint)
    horse.horseView.superview.addConstraint(horse.finishConstraint)
  }
  
  func updateContraintsToStartOfRace(horse: Horse) {
    horse.horseView.superview.removeConstraint(horse.finishConstraint)
    horse.horseView.superview.addConstraint(horse.startConstraint)
  }
  
  
  func someKindOfAsyncMethod(completionHandler: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      sleep(3)
      dispatch_async(dispatch_get_main_queue(), {
        completionHandler()})
      })
  }
}
