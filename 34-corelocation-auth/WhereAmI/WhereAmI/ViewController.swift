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
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

  @IBOutlet weak var latValLabel: UILabel!
  @IBOutlet weak var longValLabel: UILabel!
  @IBOutlet weak var altValLabel: UILabel!
  @IBOutlet weak var accValLabel: UILabel!
  @IBOutlet weak var spdValLabel: UILabel!
  @IBOutlet weak var mapView: MKMapView!

  
  let locationManager = CLLocationManager()
  
  var historicalPoints = [CLLocationCoordinate2D]()
  var routeTrack = MKPolyline()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Prepare the location manager
    locationManager.delegate = self
    locationManager.desiredAccuracy = 20
    // Need to ask for the right permissions
    locationManager.requestWhenInUseAuthorization()
    
    locationManager.startUpdatingLocation()
    // Prepare the map view
    mapView.delegate = self
  }
  
  
  // MARK:- CLLocationManagerDelegate methods
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    if let location = locations.first as? CLLocation {
      // Update the fields as expected:
      latValLabel.text = "\(location.coordinate.latitude)"
      longValLabel.text = "\(location.coordinate.longitude)"
      altValLabel.text = "\(location.altitude) m"
      accValLabel.text = "\(location.horizontalAccuracy) m"
      spdValLabel.text = "\(location.speed) ms⁻¹"
      // Re-center the map
      mapView.centerCoordinate = location.coordinate
      // And update the track on the map
      historicalPoints.append(location.coordinate)
      updateMapWithPoints(historicalPoints)
    }
  }
  
  // MARK:- MKMapViewDelegate methods
  func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    if let overlay = overlay as? MKPolyline {
      let renderer = MKPolylineRenderer(polyline: overlay)
      renderer.lineWidth = 4.0
      renderer.strokeColor = UIColor.blueColor().colorWithAlphaComponent(0.7)
      return renderer
    }
    return nil
  }
  
  
  // MARK:- Utility Methods
  private func updateMapWithPoints(points: [CLLocationCoordinate2D]) {
    let oldTrack = routeTrack
    
    // This has to be mutable, so we make a new reference
    var coordinates = points
    
    // Create the new route track
    routeTrack = MKPolyline(coordinates: &coordinates, count: points.count)
    
    // Switch them out
    mapView.addOverlay(routeTrack)
    mapView.removeOverlay(oldTrack)
    
    // Zoom the map
    mapView.visibleMapRect = mapView.mapRectThatFits(routeTrack.boundingMapRect, edgePadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
  }

}

