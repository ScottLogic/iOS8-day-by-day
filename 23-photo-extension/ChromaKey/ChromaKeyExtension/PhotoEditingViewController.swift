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
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {
  
  let filter = ChromaKeyFilter()
  var input: PHContentEditingInput?
  let formatIdentifier = "com.shinobicontrols.chromakey"
  let formatVersion    = "1.0"
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var thresholdSlider: UISlider!
  @IBAction func handleThresholdSliderChanged(sender: UISlider) {
    if abs(filter.threshold - sender.value) > 0.05 {
      updateOutputImage()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  // MARK: - PHContentEditingController
  
  func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
    // Inspect the adjustmentData to determine whether your extension can work with past edits.
    let id = adjustmentData?.formatIdentifier
    let version = adjustmentData?.formatVersion
    
    let sameVersion = version == formatVersion
    let sameId = id == formatIdentifier
    
    return sameId && sameVersion
    
    //return adjustmentData?.formatIdentifier == formatIdentifier &&
    //       adjustmentData?.formatVersion == formatVersion
  }
  
  func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
    // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
    // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
    // If you returned NO, the contentEditingInput has past edits "baked in".
    input = contentEditingInput
    filter.inputImage = CIImage(image: input?.displaySizeImage)
    if let adjustmentData = contentEditingInput?.adjustmentData {
      filter.importFilterParameters(adjustmentData.data)
    }
    thresholdSlider.value = filter.threshold
    updateOutputImage()
  }
  
  func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
    // Update UI to reflect that editing has finished and output is being rendered.
    thresholdSlider.enabled = false
    
    // Render and provide output on a background queue.
    dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
      // Create editing output from the editing input.
      let output = PHContentEditingOutput(contentEditingInput: self.input)
      
      // Provide new adjustments and render output to given location.
      let newAdjustmentData = PHAdjustmentData(formatIdentifier: self.formatIdentifier,
                                               formatVersion: self.formatVersion,
                                               data: self.filter.encodeFilterParameters())
      output.adjustmentData = newAdjustmentData
      
      // Write the JPEG Data
      let fullSizeImage = CIImage(contentsOfURL: self.input?.fullSizeImageURL)
      UIGraphicsBeginImageContext(fullSizeImage.extent().size);
      self.filter.inputImage = fullSizeImage
      UIImage(CIImage: self.filter.outputImage()).drawInRect(fullSizeImage.extent())
      let outputImage = UIGraphicsGetImageFromCurrentImageContext()
      let jpegData = UIImageJPEGRepresentation(outputImage, 1.0)
      UIGraphicsEndImageContext()
      
      jpegData.writeToURL(output.renderedContentURL, atomically: true)
      
      // Call completion handler to commit edit to Photos.
      completionHandler?(output)
      
      // Clean up temporary files, etc.
    }
  }
  
  var shouldShowCancelConfirmation: Bool {
    // Determines whether a confirmation to discard changes should be shown to the user on cancel.
    // (Typically, this should be "true" if there are any unsaved changes.)
    return false
  }
  
  func cancelContentEditing() {
    // Clean up temporary files, etc.
    // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
  }
  
  
  // MARK: - Utility methods
  private func updateOutputImage() {
    filter.threshold = thresholdSlider.value
    imageView.image = filteredImage()
  }
  
  private func filteredImage() -> UIImage {
    let outputImage = filter.outputImage
    return UIImage(CIImage: outputImage)
  }
}
