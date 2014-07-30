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

class ViewController: UIViewController {
  
  var videoFilter: CoreImageVideoFilter?
  var detector: CIDetector?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create the video filter
    videoFilter = CoreImageVideoFilter(superview: view, applyFilterCallback: {
      image in
        return self.performDetection(image)
      })
    
    // Start the video capture process
    videoFilter?.startFiltering()
  }
  
  
  func performDetection(image: CIImage) -> CIImage? {
    var resultImage: CIImage?
    if !detector {
      detector = prepareDetector()
    }
    if let detector = detector {
      // Get the detections
      let features = detector.featuresInImage(image)
      for feature in features as [CIRectangleFeature] {
        var overlay = CIImage(color: CIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5))
        overlay = overlay.imageByCroppingToRect(image.extent())
        overlay = overlay.imageByApplyingFilter("CIPerspectiveTransformWithExtent",
          withInputParameters: [
            "inputExtent": CIVector(CGRect: image.extent()),
            "inputTopLeft": CIVector(CGPoint: feature.topLeft),
            "inputTopRight": CIVector(CGPoint: feature.topRight),
            "inputBottomLeft": CIVector(CGPoint: feature.bottomLeft),
            "inputBottomRight": CIVector(CGPoint: feature.bottomRight)
          ])
        resultImage = overlay.imageByCompositingOverImage(image)
      }
    }
    return resultImage
  }
  
  func prepareDetector() -> CIDetector {
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorAspectRatio: 1.0]
    return CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: options)
  }
}

