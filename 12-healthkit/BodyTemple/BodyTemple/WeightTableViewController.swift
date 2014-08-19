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
  var weightSamples = [HKQuantitySample]()
  
  let massFormatter = NSMassFormatter()
  let dateFormatter = NSDateFormatter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Weight History"
    perfromQueryForWeightSamples()
    
    // Prepare the formatters
    massFormatter.forPersonMassUse = true
    dateFormatter.dateStyle = .MediumStyle
    dateFormatter.timeStyle = .NoStyle
  }
  
  // MARK: - Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
    // Return the number of sections.
    return 1
  }
  
  override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
    // Return the number of rows in the section.
    return weightSamples.count
  }
  
  override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    let cell = tableView.dequeueReusableCellWithIdentifier("WeightCell", forIndexPath: indexPath) as UITableViewCell
    // Configure the cell...
    let sample = weightSamples[indexPath.row]
    let weight = sample.quantity.doubleValueForUnit(HKUnit(fromString: "kg"))
    
    
    cell.detailTextLabel.text = "\(massFormatter.stringFromValue(weight, unit:.Kilogram))"
    cell.textLabel.text = "\(dateFormatter.stringFromDate(sample.startDate))"
  
    return cell
  }
  
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
    saveSampleToHealthStore(weight)
    self.weightSamples.insert(weight, atIndex: 0)
    self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
  }
  
  // MARK: - HealthStore utility methods
  func perfromQueryForWeightSamples() {
    let endDate = NSDate()
    let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMonth, value: -2, toDate: endDate, options: nil)
    
    let weightSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)
    let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
    
    let query = HKSampleQuery(sampleType: weightSampleType, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
      (query, results, error) in
      if !(results != nil) {
        println("There was an error running the query: \(error)")
      }
      
      dispatch_async(dispatch_get_main_queue()) {
        self.weightSamples = results as [HKQuantitySample]
        self.tableView.reloadData()
      }
      
      })
    
    self.healthStore?.executeQuery(query)
  }
  
  func saveSampleToHealthStore(sample: HKObject) {
    println("Saving weight")
    self.healthStore?.saveObject(sample, withCompletion: {
      (success, error) in
      if success {
        println("Weight saved successfully 😃")
      } else {
        println("Error: \(error)")
      }
      })
  }
  
}
