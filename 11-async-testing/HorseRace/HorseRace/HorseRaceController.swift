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
}


class TwoHorseRaceController {
  
  var horses: Horse[]
  var finishOffsetFromSuperview: CGFloat
  var startOffsetFromSuperview: CGFloat
  
  init(horses: Horse[], finishLine: UIView) {
    self.horses = horses
    self.finishOffsetFromSuperview = 0
    self.startOffsetFromSuperview = 0
  }
  
  func reset() {
    for horse in horses {
      updateContraintsToStartOfRace(horse)
      horse.horseView.layoutIfNeeded()
    }
  }
  
  func startRace(maxDuration: NSTimeInterval, horseCrossedLineCallback: (Horse) -> ()) {
    for horse in horses {
      // Generate a random time
      let duration = maxDuration
      // Perform the animation
      UIView.animateWithDuration(duration,
        animations: {
          self.updateConstraintsToEndOfRace(horse)
          horse.horseView.layoutIfNeeded()
        },
        completion: { _ -> () in
          horseCrossedLineCallback(horse)
        })
    }
  }
  
  func updateConstraintsToEndOfRace(horse: Horse) {
    horse.horseView.removeConstraint(horse.startConstraint)
    // Create the end constraint
  }
  
  func updateContraintsToStartOfRace(horse: Horse) {
    horse.horseView.removeConstraint(horse.finishConstraint)
    horse.horseView.addConstraint(horse.startConstraint)
  }
}