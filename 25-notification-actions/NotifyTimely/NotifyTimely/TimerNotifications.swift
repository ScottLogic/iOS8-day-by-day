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
import UIKit

protocol TimerNotificationManagerDelegate {
  func timerStatusChanged()
}

class TimerNotificationManager: Printable {
  var timerRunning = false
  var delegate: TimerNotificationManagerDelegate?
  var timerDuration: Float {
    didSet {
      delegate?.timerStatusChanged()
    }
  }
  
  var description: String {
    return "Timer Duration: \(timerDuration). Currently Running: \(timerRunning)"
  }

  init() {
    timerDuration = 30.0
    registerForNotifications()
  }
  
  func startTimer() {
    if !timerRunning {
      // Create the notification...
      
      timerRunning = true
      delegate?.timerStatusChanged()
    }
  }
  
  func stopTimer() {
    if timerRunning {
      // Kill the notification
      
      timerRunning = false
      delegate?.timerStatusChanged()
    }
  }
  
  func restartTimer() {
    if timerRunning {
      stopTimer()
      startTimer()
    }
  }
  
  
  private func registerForNotifications() {
    let requestedTypes = UIUserNotificationType.Alert | .Sound
    let settingsRequest = UIUserNotificationSettings(forTypes: requestedTypes, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(settingsRequest)
  }
}
