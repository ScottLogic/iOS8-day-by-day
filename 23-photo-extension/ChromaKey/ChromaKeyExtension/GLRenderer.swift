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
import GLKit

class GLRenderer {
  
  var glView: GLKView
  var renderContext: CIContext!
  
  init(glView: GLKView) {
    self.glView = glView
    self.renderContext = CIContext(EAGLContext: glView.context)
  }
  
  convenience init(frame: CGRect, superview: UIView) {
    let view = GLKView(frame: frame, context: EAGLContext(API: .OpenGLES2))
    view.frame = frame
    superview.addSubview(view)
    self.init(glView: view)
  }
  
  func renderImage(image: CIImage) {
    glView.bindDrawable()
    if glView.context != EAGLContext.currentContext() {
      EAGLContext.setCurrentContext(glView.context)
    }
    
    // Calculate the position and size of the image within the GLView
    // This code is equivalent to UIViewContentModeScaleAspectFit
    let imageSize = image.extent().size
    var drawFrame = CGRectMake(0, 0, CGFloat(glView.drawableWidth), CGFloat(glView.drawableHeight))
    let imageAR = imageSize.width / imageSize.height
    let viewAR = drawFrame.width / drawFrame.height
    if imageAR > viewAR {
      drawFrame.origin.y += (drawFrame.height - drawFrame.width / imageAR) / 2.0
      drawFrame.size.height = drawFrame.width / imageAR
    } else {
      drawFrame.origin.x += (drawFrame.width - drawFrame.height * imageAR) / 2.0
      drawFrame.size.width = drawFrame.height * imageAR
    }
    
    // clear eagl view to black
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(0x00004000)
    
    // set the blend mode to "source over" so that CI will use that
    glEnable(0x0BE2);
    glBlendFunc(1, 0x0303);
    
    renderContext.drawImage(image, inRect: drawFrame, fromRect: image.extent())
    
    glView.display()
  }
  
}
