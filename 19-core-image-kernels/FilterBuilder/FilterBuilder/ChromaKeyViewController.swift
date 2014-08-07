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

class ChromaKeyViewController: UIViewController {
  
  // MARK: - Properties
  let filter = ChromaKeyFilter()
  
  // MARK: - IBOutlets
  @IBOutlet weak var outputImageView: UIImageView!
  @IBOutlet weak var thresholdSlider: UISlider!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupFilter()
    updateOutputImage()
  }
  
  // MARK: - IBActions
  @IBAction func handleThresholdSliderChanged(sender: UISlider) {
    if abs(filter.threshold - CGFloat(sender.value)) > 0.05 {
      updateOutputImage()
    }
  }
  
  // MARK: - Utility methods
  private func updateOutputImage() {
    filter.threshold = CGFloat(thresholdSlider.value)
    outputImageView.image = filteredImage()
  }
  
  private func filteredImage() -> UIImage {
    let outputImage = filter.outputImage
    return UIImage(CIImage: outputImage)
  }
  
  private func setupFilter() {
    // Image (C) Cristian Borquez
    // https://flic.kr/p/7hhXk1
    let inputImage = UIImage(named: "chroma_key")
    filter.inputImage = CIImage(image: inputImage)
    filter.activeColor = CIColor(red: 0, green: 1, blue: 0)
  }

}

