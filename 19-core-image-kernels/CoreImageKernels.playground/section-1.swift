import UIKit
import CoreImage

// MARK: - ChromaKey Filter
// MARK: -

class ChromaKeyFilter: CIFilter {
  // MARK: - Properties
  var kernel: CIColorKernel?
  var inputImage: CIImage?
  var activeColor: CIColor?
  
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
        var args = [inputImage as AnyObject]
        return kernel.applyWithExtent(dod, arguments: args)
      }
    }
    return nil
  }
  
  // MARK: - Utility methods
  private func createKernel() -> CIColorKernel {
    let kernelString =
    "kernel vec4 passThrough( __sample s) { " +
    "  return s.rgba; " +
    "}"
    return CIColorKernel(string: kernelString)
  }
}

let context = CIContext(options: nil)
let inputImage = UIImage(named: "chroma_key_sample.jpg")
let chromaKeyFilter = ChromaKeyFilter()
let ciimage = CIImage.emptyImage()

let ciInputImage = CIImage(CGImage: inputImage.CGImage)
chromaKeyFilter.inputImage = ciInputImage





