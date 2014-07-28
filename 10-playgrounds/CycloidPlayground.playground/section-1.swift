import UIKit
import XCPlayground

let radius = 10.0

for circleProp in 1...100 {
  let alpha = Double(circleProp) / 100.0 * 2.0 * M_PI
  let y = radius * (1 - cos(alpha))
  let x = radius * (alpha - sin(alpha))
}


class Cycloid: NSObject {
  var radius: Double
  var numberOfRotations: Double
  
  init(radius: Double, numberOfRotations: Double = 2.5) {
    self.radius = radius
    self.numberOfRotations = numberOfRotations
    super.init()
  }
  
  func generateDatapoint(angle: Double) -> CGPoint {
    let y = radius * (1 - cos(angle))
    let x =  radius * (angle - sin(angle))
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
  }
  
  func debugQuickLookObject() -> AnyObject? {
    let bezierPath = UIBezierPath()
    bezierPath.moveToPoint(CGPoint.zeroPoint)
    for runProp in 1...100 {
      let angle = Double(runProp) / 100.0 * 2.0 * M_PI * numberOfRotations
      bezierPath.addLineToPoint(generateDatapoint(angle))
    }
    return bezierPath
  }
}

let c = Cycloid(radius: 50, numberOfRotations: 3)

