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
import HealthKit

protocol WeightEntryDelegate {
  func weightEntryDidComplete(weight: HKQuantitySample)
}

class WeightEntryViewController: UIViewController {
  
  var weightEntryDelegate: WeightEntryDelegate?
  
  @IBOutlet var datePicker: UIDatePicker!
  @IBOutlet var weightEntryTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    datePicker.maximumDate = NSDate()
    title = "Add Weight Record"
  }
  
  
  @IBAction func handleSaveButtonTapped(sender: AnyObject) {
    if let massNumber = numberString(weightEntryTextField.text) {
      let weightType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
      let weightValue = HKQuantity(unit: HKUnit(fromString: "kg"), doubleValue: massNumber)
      let metadata = [ HKMetadataKeyWasUserEntered : true ]
      let sample = HKQuantitySample(type: weightType, quantity: weightValue, startDate: datePicker.date, endDate: datePicker.date, metadata: metadata)
      weightEntryDelegate?.weightEntryDidComplete(sample)
    }
    navigationController.popViewControllerAnimated(true)
  }
  
  //MARK: Utility functions
  func numberString(input: String) -> Double? {
    let formatter = NSNumberFormatter()
    var result: Double? = nil
    let parsed = formatter.numberFromString(input)
    if let parsed = parsed {
      result = parsed as Double
    }
    return result
  }
  
  
}
