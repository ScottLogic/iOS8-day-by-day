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
  
  @IBOutlet var qrDecodeLabel: UILabel!
  @IBOutlet var detectorModeSelector: UISegmentedControl!
  
  var videoFilter: CoreImageVideoFilter?
  var detector: CIDetector?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create the video filter
    videoFilter = CoreImageVideoFilter(superview: view, applyFilterCallback: nil)
    
    // Simulate a tap on the mode selector to start the process
    detectorModeSelector.selectedSegmentIndex = 0
    handleDetectorSelectionChange(detectorModeSelector)
  }
  
  @IBAction func handleDetectorSelectionChange(sender: UISegmentedControl) {
    if let videoFilter = videoFilter {
      videoFilter.stopFiltering()
      self.qrDecodeLabel.hidden = true
      
      switch sender.selectedSegmentIndex {
      case 0:
        detector = prepareRectangleDetector()
        videoFilter.applyFilter = {
          image in
          return self.performRectangleDetection(image)
        }
      case 1:
        self.qrDecodeLabel.hidden = false
        detector = prepareQRCodeDetector()
        videoFilter.applyFilter = {
          image in
          let found = self.performQRCodeDetection(image)
          dispatch_async(dispatch_get_main_queue()) {
            if found.decode != "" {
              self.qrDecodeLabel.text = found.decode
            }
          }
          return found.outImage
        }
      default:
        videoFilter.applyFilter = nil
      }
      
      videoFilter.startFiltering()
    }
  }
  
  
  //MARK: Utility methods
  func performRectangleDetection(image: CIImage) -> CIImage? {
    var resultImage: CIImage?
    if let detector = detector {
      // Get the detections
      let features = detector.featuresInImage(image)
      for feature in features as [CIRectangleFeature] {
        resultImage = drawHighlightOverlayForPoints(image, topLeft: feature.topLeft, topRight: feature.topRight,
                                                    bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
      }
    }
    return resultImage
  }
  
  func performQRCodeDetection(image: CIImage) -> (outImage: CIImage?, decode: String) {
    var resultImage: CIImage?
    var decode = ""
    if let detector = detector {
      let features = detector.featuresInImage(image)
      for feature in features as [CIQRCodeFeature] {
        resultImage = drawHighlightOverlayForPoints(image, topLeft: feature.topLeft, topRight: feature.topRight,
          bottomLeft: feature.bottomLeft, bottomRight: feature.bottomRight)
        decode = feature.messageString
      }
    }
    return (resultImage, decode)
  }
  
  func prepareRectangleDetector() -> CIDetector {
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorAspectRatio: 1.0]
    return CIDetector(ofType: CIDetectorTypeRectangle, context: nil, options: options)
  }
  
  func prepareQRCodeDetector() -> CIDetector {
    let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    return CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: options)
  }
  
  func drawHighlightOverlayForPoints(image: CIImage, topLeft: CGPoint, topRight: CGPoint,
                                     bottomLeft: CGPoint, bottomRight: CGPoint) -> CIImage {
    var overlay = CIImage(color: CIColor(red: 1.0, green: 0, blue: 0, alpha: 0.5))
    overlay = overlay.imageByCroppingToRect(image.extent())
    overlay = overlay.imageByApplyingFilter("CIPerspectiveTransformWithExtent",
      withInputParameters: [
        "inputExtent": CIVector(CGRect: image.extent()),
        "inputTopLeft": CIVector(CGPoint: topLeft),
        "inputTopRight": CIVector(CGPoint: topRight),
        "inputBottomLeft": CIVector(CGPoint: bottomLeft),
        "inputBottomRight": CIVector(CGPoint: bottomRight)
      ])
    return overlay.imageByCompositingOverImage(image)
  }
}

