//
//  ViewController.swift
//  HorseRace
//
//  Created by Sam Davies on 27/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  
  @IBOutlet var horse1: UIImageView
  @IBOutlet var horse2: UIImageView
  @IBOutlet var horse1StartConstraint: NSLayoutConstraint
  @IBOutlet var horse2StartConstraint: NSLayoutConstraint
  
  
  var raceController: TwoHorseRaceController!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    raceController = createRaceController()
    
  }
  
  @IBAction func handleStartRaceButton(sender: UIButton) {
    raceController.startRace(5, horseCrossedLineCallback:{
      (horse:Horse) in
      switch horse.horseView {
      case self.horse1:
        println("Horse 1 has completed the race!")
      case self.horse2:
        println("Horse 2 has completed the race!")
      default:
        println("That horse wasn't in the race")
      }
    })
  }
  
  @IBAction func handleResetRaceButton(sender: UIButton) {
    raceController.reset()
  }
  
  
  // Utility methods
  func createRaceController() -> TwoHorseRaceController {
    let h1 = Horse(horseView: horse1, startConstraint: horse1StartConstraint, finishLineOffset: 0)
    let h2 = Horse(horseView: horse2, startConstraint: horse2StartConstraint, finishLineOffset: 0)
    
    return TwoHorseRaceController(horses: [h1, h2])
  }
}

