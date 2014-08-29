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
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var thresholdSlider: UISlider!
  @IBAction func handleThresholdSliderChanged(sender: UISlider) {
    if abs(filter.threshold - CGFloat(sender.value)) > 0.05 {
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
    return adjustmentData?.formatIdentifier == "com.shinobicontrols.chromakey" &&
           adjustmentData?.formatVersion == "1.0"
  }
  
  func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
    // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
    // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
    // If you returned NO, the contentEditingInput has past edits "baked in".
    input = contentEditingInput
    filter.inputImage = CIImage(image: input?.displaySizeImage)
    filter.activeColor = CIColor(red: 0, green: 1, blue: 0)
    updateOutputImage()
  }
  
  func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
    // Update UI to reflect that editing has finished and output is being rendered.
    
    // Render and provide output on a background queue.
    dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
      // Create editing output from the editing input.
      let output = PHContentEditingOutput(contentEditingInput: self.input)
      
      // Provide new adjustments and render output to given location.
      // output.adjustmentData = <#new adjustment data#>
      // let renderedJPEGData = <#output JPEG#>
      // renderedJPEGData.writeToURL(output.renderedContentURL, atomically: true)
      
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
    filter.threshold = CGFloat(thresholdSlider.value)
    imageView.image = filteredImage()
  }
  
  private func filteredImage() -> UIImage {
    let outputImage = filter.outputImage
    return UIImage(CIImage: outputImage)
  }
  
}
