//
// Copyright 2014 Scott Logic
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
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var actionButton: UIButton!
  
  var annotation: MKPointAnnotation?
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Ask for permission for notifications
    let notificationSettings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    
    // Ask for permission for location
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }

  @IBAction func handleButtonPressed(sender: UIButton) {
    // Painfully lazy and bad-style state machine
    if actionButton.titleForState(.Normal) == "Drop Pin" {
      annotation = MKPointAnnotation()
      annotation?.coordinate = mapView.centerCoordinate
      mapView.addAnnotation(annotation)
      actionButton.setTitle("Notify Me", forState: .Normal)
    } else if actionButton.titleForState(.Normal) == "Notify Me" {
      // Create a notification
      UIApplication.sharedApplication().cancelAllLocalNotifications()
      let notification = UILocalNotification()
      notification.alertBody = "You're nearly there!"
      notification.regionTriggersOnce = true
      notification.region = CLCircularRegion(center: annotation!.coordinate, radius: 50, identifier: "Destination")
      println("\(notification), \(notification.region)")
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
      
      actionButton.setTitle("Cancel Notification", forState: .Normal)
    } else if actionButton.titleForState(.Normal) == "Cancel Notification" {
      UIApplication.sharedApplication().cancelAllLocalNotifications()
      mapView.removeAnnotation(annotation)
      actionButton.setTitle("Drop Pin", forState: .Normal)
    }
  }
  
  // MARK:- MKMapViewDelegate methods
  func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
    let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PinAnnotation")
    pin.animatesDrop = true
    return pin
  }
  
  // MARK:- CLLocationManagerDelegate
  func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedWhenInUse {
      println("Ready to go!")
    }
  }

}

