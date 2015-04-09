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

public class ViewController: UIViewController {
  
  @IBOutlet public weak var horse1: UIImageView!
  @IBOutlet public weak var horse2: UIImageView!
  @IBOutlet weak var horse1StartConstraint: NSLayoutConstraint!
  @IBOutlet weak var horse2StartConstraint: NSLayoutConstraint!
  
  @IBOutlet public weak var startRaceButton: UIButton!
  @IBOutlet public weak var resetButton: UIButton!
  
  public var raceController: TwoHorseRaceController!
  private var numberOfHorsesCurrentlyRunning = 0
  
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    raceController = createRaceController()
    resetButton.enabled = false
    
  }
  
  @IBAction public func handleStartRaceButton(sender: UIButton) {
    numberOfHorsesCurrentlyRunning = 2
    startRaceButton.enabled = false
    raceController.startRace(5, horseCrossedLineCallback:{
      (horse:Horse) in
      // Deal with the number of horses
      self.numberOfHorsesCurrentlyRunning -= 1
      if self.numberOfHorsesCurrentlyRunning == 0 {
        self.resetButton.enabled = true
      }
      
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
    startRaceButton.enabled = true
    resetButton.enabled = false
  }
  
  
  // Utility methods
  func createRaceController() -> TwoHorseRaceController {
    let h1 = Horse(horseView: horse1, startConstraint: horse1StartConstraint, finishLineOffset: 0)
    let h2 = Horse(horseView: horse2, startConstraint: horse2StartConstraint, finishLineOffset: 0)
    
    return TwoHorseRaceController(horses: [h1, h2])
  }
}

