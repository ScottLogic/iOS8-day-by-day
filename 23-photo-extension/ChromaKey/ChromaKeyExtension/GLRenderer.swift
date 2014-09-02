//
//  GLRenderer.swift
//  ChromaKey
//
//  Created by Sam Davies on 01/09/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
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
