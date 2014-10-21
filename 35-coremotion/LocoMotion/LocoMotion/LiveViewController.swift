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
import CoreMotion

class LiveViewController: UIViewController {
  
  @IBOutlet weak var activityImageView: UIImageView!
  @IBOutlet weak var stepsLabel: UILabel!
  @IBOutlet weak var floorsLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var altitudeLabel: UILabel!
  
  let dataProcessingQueue = NSOperationQueue()
  let pedometer = CMPedometer()
  let altimeter = CMAltimeter()
  let activityManager = CMMotionActivityManager()
  
  let lengthFormatter = NSLengthFormatter()
  
  var altChange: Double = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    lengthFormatter.numberFormatter.usesSignificantDigits = false
    lengthFormatter.numberFormatter.maximumSignificantDigits = 2
    lengthFormatter.unitStyle = .Short
    
    
    // Prepare altimeter
    altimeter.startRelativeAltitudeUpdatesToQueue(dataProcessingQueue) {
      (data, error) in
      if error != nil {
        println("There was an error obtaining altimeter data: \(error)")
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          self.altChange += data.relativeAltitude
          self.altitudeLabel.text = "\(self.lengthFormatter.stringFromMeters(self.altChange))"
        }
      }
    }
    
    // Prepare pedometer
    pedometer.startPedometerUpdatesFromDate(NSDate()) {
      (data, error) in
      if error != nil {
        println("There was an error obtaining pedometer data: \(error)")
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          self.floorsLabel.text = "\(data.floorsAscended)"
          self.stepsLabel.text = "\(data.numberOfSteps)"
          self.distanceLabel.text = "\(self.lengthFormatter.stringFromMeters(data.distance))"
        }
      }
    }
    
    // Prepare activity updates
    activityManager.startActivityUpdatesToQueue(dataProcessingQueue) {
      data in
      dispatch_async(dispatch_get_main_queue()) {
        if data.running {
          self.activityImageView.image = UIImage(named: "run")
        } else if data.cycling {
          self.activityImageView.image = UIImage(named: "cycle")
        } else if data.walking {
          self.activityImageView.image = UIImage(named: "walk")
        } else {
          self.activityImageView.image = nil
        }
      }
    }
  }

}

