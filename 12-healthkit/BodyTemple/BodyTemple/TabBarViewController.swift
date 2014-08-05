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

class TabBarViewController: UITabBarController {

  var healthStore: HKHealthStore?
  
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    createAndPropagateHealthStore()
  }
  
  override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    createAndPropagateHealthStore()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    requestAuthorisationForHealthStore()
  }
  
  private func createAndPropagateHealthStore() {
    if self.healthStore == nil {
      self.healthStore = HKHealthStore()
    }
    
    for vc in viewControllers {
      if let healthStoreUser = vc as? HealthStoreUser {
        healthStoreUser.healthStore = self.healthStore
      }
    }
  }
  
  private func requestAuthorisationForHealthStore() {
    let dataTypesToWrite = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
    ]
    let dataTypesToRead = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex),
      HKCharacteristicType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)
    ]
    
    self.healthStore?.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite),
      readTypes: NSSet(array: dataTypesToRead), completion: {
      (success, error) in
        if success {
          println("User completed authorisation request.")
        } else {
          println("The user cancelled the authorisation request. \(error)")
        }
      })
  }
}
