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
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

  @IBOutlet weak var mapView: MKMapView!
  let activityType = "com.shinobicontrols.MapOff.viewport"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    if userActivity?.activityType != activityType {
      userActivity?.invalidate()
      userActivity = NSUserActivity(activityType: activityType)
    }
    
    userActivity?.needsSave = true
    mapView.delegate = self
  }
  
  // MARK:- UIResponder Activity Handling
  override func updateUserActivityState(activity: NSUserActivity) {
    let regionData = withUnsafePointer(&mapView.region) {
      NSData(bytes: $0, length: sizeof(MKCoordinateRegion))
    }
    activity.userInfo = ["region" : regionData]
  }
  
  override func restoreUserActivityState(activity: NSUserActivity) {
    if activity.activityType == activityType {
      // Extract the data
      let regionData = activity.userInfo!["region"] as! NSData
      // Need an empty coordinate region to populate
      var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                        span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0))
      regionData.getBytes(&region, length: sizeof(MKCoordinateRegion))
      mapView.setRegion(region, animated: true)
    }
  }
  
  // MARK:- MKMapViewDelegate
  func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
    userActivity?.needsSave = true
  }

}

