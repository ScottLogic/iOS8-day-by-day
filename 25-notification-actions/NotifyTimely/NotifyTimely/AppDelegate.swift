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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  let timerNotificationManager = TimerNotificationManager()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    if let vc = window?.rootViewController as? ViewController {
      vc.timerNotificationManager = timerNotificationManager
    }
    
    return true
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    // Pass the "firing" event onto the notification manager
    timerNotificationManager.timerFired()
    if application.applicationState == .Active {
      let alert = UIAlertController(title: "NotifyTimely", message: "Your time is up", preferredStyle: .Alert)
      // Handler for each of the actions
      let actionAndDismiss = {
        (action: String?) -> ((UIAlertAction!) -> ()) in
        return {
          _ in
          self.timerNotificationManager.handleActionWithIdentifier(action)
          self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
      }
      
      alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: actionAndDismiss(nil)))
      alert.addAction(UIAlertAction(title: "Restart", style: .Default, handler: actionAndDismiss(restartTimerActionString)))
      alert.addAction(UIAlertAction(title: "Snooze", style: .Destructive, handler: actionAndDismiss(snoozeTimerActionString)))
      window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }
  }
  
  func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
    // Pass the action name onto the manager
    timerNotificationManager.handleActionWithIdentifier(identifier)
    completionHandler()
  }

}

