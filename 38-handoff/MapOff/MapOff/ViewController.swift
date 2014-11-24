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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let activityType = "com.shinobicontrols.MapOff.viewport"
    if userActivity?.activityType != activityType {
      userActivity?.invalidate()
      userActivity = NSUserActivity(activityType: activityType)
    }
    
    userActivity?.needsSave = true
    mapView.delegate = self
  }
  
  override func updateUserActivityState(activity: NSUserActivity) {
    let regionData = NSData(bytes: &mapView.region, length: sizeof(MKCoordinateRegion))
    activity.userInfo = ["region" : regionData]
  }
  
  // MARK:- MKMapViewDelegate
  func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
    userActivity?.needsSave = true
  }

}

