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


class MotionActivityCell: UITableViewCell {
  
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var pedometerLabel: UILabel!
  
  
  var activity: Activity? {
    didSet {
      prepareCellForActivity(activity)
    }
  }
  
  var dateFormatter: NSDateFormatter?
  var lengthFormatter: NSLengthFormatter?
  var pedometer: CMPedometer?
  
  
  // MARK:- Utility methods
  private func prepareCellForActivity(activity: Activity?) {
    if let activity = activity {
      var imageName = ""
      switch activity.type {
      case .Cycling:
        imageName = "cycle"
        pedometerLabel.text = ""
      case .Running:
        imageName = "run"
        requestPedometerData()
      case .Walking:
        imageName = "walk"
        requestPedometerData()
      default:
        imageName = ""
        pedometerLabel.text = ""
      }

      iconImageView.image = UIImage(named: imageName)
      titleLabel.text = "\(dateFormatter!.stringFromDate(activity.startDate)) - \(dateFormatter!.stringFromDate(activity.endDate))"
    }
  }
  
  private func requestPedometerData() {
    pedometer?.queryPedometerDataFromDate(activity?.startDate, toDate: activity?.endDate) {
      (data, error) -> Void in
      if error != nil {
        println("There was an error requesting data from the pedometer: \(error)")
      } else {
        dispatch_async(dispatch_get_main_queue()) {
          self.pedometerLabel.text = self.constructPedometerString(data)
        }
      }
    }
  }
  
  private func constructPedometerString(data: CMPedometerData) -> String {
    var pedometerString = ""
    if CMPedometer.isStepCountingAvailable() {
      pedometerString += "\(data.numberOfSteps) steps | "
    }
    if CMPedometer.isDistanceAvailable() {
      pedometerString += "\(lengthFormatter!.stringFromMeters(data.distance)) | "
    }
    if CMPedometer.isFloorCountingAvailable() {
      pedometerString += "\(data.floorsAscended) floors"
    }
    return pedometerString
  }

}
