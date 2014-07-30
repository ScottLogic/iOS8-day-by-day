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
import GLKit
import AVFoundation
import CoreMedia
import CoreImage
import OpenGLES
import QuartzCore

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
                            
  var videoDisplayView: GLKView!
  var videoDisplayViewBounds: CGRect!
  var renderContext: CIContext!
  
  var avSession: AVCaptureSession!
  var sessionQueue: dispatch_queue_t!
  
  var detector: CIDetector?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    videoDisplayView = GLKView(frame: view.bounds, context: EAGLContext(API: .OpenGLES2))
    videoDisplayView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
    videoDisplayView.frame = view.bounds
    view.addSubview(videoDisplayView)
    
    renderContext = CIContext(EAGLContext: videoDisplayView.context)
    sessionQueue = dispatch_queue_create("AVSessionQueue", DISPATCH_QUEUE_SERIAL)
    
    videoDisplayView.bindDrawable()
    videoDisplayViewBounds = CGRect(x: 0, y: 0, width: videoDisplayView.drawableWidth, height: videoDisplayView.drawableHeight)
    
    // Start the video capture process
    start()
  }
  
  deinit {
    dispatch_release(sessionQueue)
  }
  
  func start() {
    // Input from video camera
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var error: NSError?
    let input = AVCaptureDeviceInput(device: device, error: &error)

    // Start out with low quality
    avSession = AVCaptureSession()
    avSession.sessionPreset = AVCaptureSessionPresetMedium
    
    // Output
    let videoOutput = AVCaptureVideoDataOutput()
    
    videoOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA]
    videoOutput.alwaysDiscardsLateVideoFrames = true
    videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
    
    // Join it all together
    avSession.addInput(input)
    avSession.addOutput(videoOutput)
    
    // And kick it off
    avSession.startRunning()
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
  
  //MARK: <AVCaptureVideoDataOutputSampleBufferDelegate
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
    
    // Need to shimmy this through type-hell
    let opaqueBuffer = CMSampleBufferGetImageBuffer(sampleBuffer).toOpaque()
    let imageBuffer = Unmanaged<CVPixelBuffer>.fromOpaque(opaqueBuffer).takeUnretainedValue()
    let sourceImage = CIImage(CVPixelBuffer: imageBuffer, options: nil)
    
    // Do some detection on the image
    let detectionResult = performDetection(sourceImage)
    var outputImage = sourceImage
    if detectionResult {
      outputImage = detectionResult!
    }
    
    // Do some clipping
    var drawFrame = outputImage.extent()
    let imageAR = drawFrame.width / drawFrame.height
    let viewAR = videoDisplayViewBounds.width / videoDisplayViewBounds.height
    if imageAR > viewAR {
      drawFrame.origin.x += (drawFrame.width - drawFrame.height * viewAR) / 2.0
      drawFrame.size.width = drawFrame.height / viewAR
    } else {
      drawFrame.origin.y += (drawFrame.height - drawFrame.width / viewAR) / 2.0
      drawFrame.size.height = drawFrame.width / viewAR
    }
    
    videoDisplayView.bindDrawable()
    if videoDisplayView.context != EAGLContext.currentContext() {
      EAGLContext.setCurrentContext(videoDisplayView.context)
    }
    
    // clear eagl view to grey
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(0x00004000)
    
    // set the blend mode to "source over" so that CI will use that
    glEnable(0x0BE2);
    glBlendFunc(1, 0x0303);
    
    renderContext.drawImage(outputImage, inRect: videoDisplayViewBounds, fromRect: drawFrame)
    
    videoDisplayView.display()
    
  }

}

