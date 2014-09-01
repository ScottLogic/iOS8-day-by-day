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
  var glViewBounds: CGRect
  var renderContext: CIContext!
  
  
  init(glView: GLKView) {
    self.glView = glView
    self.renderContext = CIContext(EAGLContext: glView.context)
    self.glViewBounds = CGRect(x: 0, y: 0, width: glView.drawableWidth, height: glView.drawableHeight)
  }
  
  convenience init(frame: CGRect, superview: UIView) {
    let view = GLKView(frame: frame, context: EAGLContext(API: .OpenGLES2))
    view.frame = frame
    superview.addSubview(view)
    self.init(glView: view)
  }
  
  func renderImage(image: CIImage) {
    var drawFrame = image.extent()
    /*let imageAR = drawFrame.width / drawFrame.height
    let viewAR = glViewBounds.width / glViewBounds.height
    if imageAR > viewAR {
      drawFrame.origin.x += (drawFrame.width - drawFrame.height * viewAR) / 2.0
      drawFrame.size.width = drawFrame.height / viewAR
    } else {
      drawFrame.origin.y += (drawFrame.height - drawFrame.width / viewAR) / 2.0
      drawFrame.size.height = drawFrame.width / viewAR
    }
    */
    glView.bindDrawable()
    if glView.context != EAGLContext.currentContext() {
      EAGLContext.setCurrentContext(glView.context)
    }
    
    // clear eagl view to grey
    glClearColor(0.5, 0.5, 0.5, 1.0);
    glClear(0x00004000)
    
    // set the blend mode to "source over" so that CI will use that
    glEnable(0x0BE2);
    glBlendFunc(1, 0x0303);
    
    
    renderContext.drawImage(image, inRect: drawFrame, fromRect: drawFrame)
    
    glView.display()

  }
  
  
}
