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

class MedianViewController: UIViewController {
  
  // MARK: - Properties
  let filter = MedianFilter()
  
  // MARK: - IBOutlets
  @IBOutlet weak var outputImageView: UIImageView!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupFilter()
    updateOutputImage()
  }
  
  // MARK: - Utility methods
  private func updateOutputImage() {
    outputImageView.image = filteredImage()
  }
  
  private func filteredImage() -> UIImage {
    let outputImage = filter.outputImage
    return UIImage(CIImage: outputImage)
  }
  
  private func setupFilter() {
    // Need an input image
    let inputImage = UIImage(named: "")
    filter.inputImage = CIImage(image: inputImage)
  }
  
}

