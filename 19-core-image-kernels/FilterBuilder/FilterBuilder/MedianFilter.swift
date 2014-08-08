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

import CoreImage

class MedianFilter: CIFilter {
  // MARK: - Properties
  var kernel: CIKernel?
  var inputImage: CIImage?

  // MARK: - Initialization
  override init() {
    super.init()
    kernel = createKernel()
  }
  
  required init(coder aDecoder: NSCoder!) {
    super.init(coder: aDecoder)
    kernel = createKernel()
  }
  
  // MARK: - API
  func outputImage() -> CIImage? {
    if let inputImage = inputImage {
      let dod = inputImage.extent()
      if let kernel = kernel {
        // Something here
        let velocity = CIVector(x: 15, y: 6)
        let args = [inputImage as AnyObject, velocity as AnyObject]
        let dod = inputImage.extent().rectByInsetting(dx: -abs(velocity.X()), dy: -abs(velocity.Y()))
        return kernel.applyWithExtent(dod, roiCallback: {
          (index, rect) in
          return rect.rectByInsetting(dx: -abs(velocity.X()), dy: -abs(velocity.Y()))
          }, arguments: args)
      }
    }
    return nil
  }
  
  // MARK: - Utility methods
  private func createKernel() -> CIKernel {
    let kernelString =
    "kernel vec4 motionBlur (sampler image, vec2 velocity) {\n" +
    "  const int NUM_SAMPLES = 10;\n" +
    "  vec4 s = vec4(0.0);\n" +
    "  vec2 dc = destCoord();\n" +
    "  vec2 offset = -velocity;\n" +
    "  for (int i=0; i < (NUM_SAMPLES * 2 + 1); i++) {\n" +
    "    s += sample (image, samplerTransform( image, dc + offset ));\n" +
    "    offset += velocity / float(NUM_SAMPLES);\n" +
    "  }\n" +
    "  return s / float((NUM_SAMPLES * 2 + 1));\n" +
    "}"
    return CIColorKernel(string: kernelString)
  }
  
  
}
