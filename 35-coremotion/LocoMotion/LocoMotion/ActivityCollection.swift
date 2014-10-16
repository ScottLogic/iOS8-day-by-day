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

import Foundation
import CoreMotion


enum ActivityType {
  case Cycling
  case Running
  case Walking
  case Other
}

struct Activity {
  let type: ActivityType
  let startDate: NSDate
  let endDate: NSDate
  
  init(motionActivity: CMMotionActivity) {
    if motionActivity.cycling {
      type = .Cycling
    } else if motionActivity.running {
      type = .Running
    } else if motionActivity.walking {
      type = .Walking
    } else {
      type = .Other
    }
    startDate = motionActivity.startDate
    endDate = motionActivity.startDate
  }
  
  init(activity: Activity, newEndDate: NSDate) {
    type = activity.type
    startDate = activity.startDate
    endDate = newEndDate
  }
  
  func appendActivity(activity: Activity) -> Activity {
    return Activity(activity: self, newEndDate: activity.endDate)
  }
  
}


class ActivityCollection {
  var activities = [Activity]()

  init(activities: [CMMotionActivity]) {
    addMotionActivities(activities)
  }
  
  func addMotionActivity(motionActivity: CMMotionActivity) {
    var activity = Activity(motionActivity: motionActivity)
    
    if activities.last?.type == activity.type {
      // Need to combine them
      activity = activities.last!.appendActivity(activity)
      activities.removeLast()
    }
    if (activity.type != .Other) {
      activities.append(activity)
    }
  }
  
  func addMotionActivities(motionActivities: [CMMotionActivity]) {
    for activity in motionActivities {
      addMotionActivity(activity)
    }
  }
}


