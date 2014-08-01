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

class WeightTableViewController: UITableViewController, WeightEntryDelegate, HealthStoreUser {
  
  var healthStore: HKHealthStore?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Weight History"
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0
  }
  /*
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
  let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
  
  // Configure the cell...
  
  return cell
  }
*/
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if segue.identifier == "addWeightSample" {
      if let weightEntryVC = segue.destinationViewController as? WeightEntryViewController {
        weightEntryVC.weightEntryDelegate = self
      }
    }
  }
  
  // MARK: - WeightEntryDelegate
  func weightEntryDidComplete(weight: HKQuantitySample) {
    println("Saving weight")
    self.healthStore?.saveObject(weight, withCompletion: {
      (success, error) in
      if success {
        println("Weight saved successfully 😃")
      } else {
        println("Error: \(error)")
      }
      })
  }
  
}
