import UIKit
import QuartzCore
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
  
  func pointsForCycloid(numberSamples: UInt) -> [CGPoint] {
    var dataPoints = [CGPoint]()
    for sampleIndex in 0..<numberSamples {
      let angle = Double(sampleIndex) / Double(numberSamples) * 2.0 * M_PI * numberOfRotations
      dataPoints.append(generateDatapoint(angle))
    }
    return dataPoints
  }
  
  func bezierPath(numberSamples: UInt) -> UIBezierPath {
    let bezierPath = UIBezierPath()
    bezierPath.moveToPoint(CGPoint.zeroPoint)
    for point in pointsForCycloid(numberSamples) {
      bezierPath.addLineToPoint(point)
    }
    return bezierPath
  }
  
  func debugQuickLookObject() -> AnyObject? {
    return bezierPath(100)
  }
}

let c = Cycloid(radius: 50, numberOfRotations: 3)



class AnimatingCycloidView: UIView {
  var cycloid: Cycloid
  var wheelLayer: CAShapeLayer
  var cycloidLayer: CAShapeLayer
  
  init(frame: CGRect) {
    let radius: Double = Double(frame.height) / 2.0
    let numberOfRotations: Double = Double(frame.width) / (2.0 * M_PI * radius)
    cycloid = Cycloid(radius: radius, numberOfRotations: numberOfRotations)
    
    wheelLayer = CAShapeLayer()
    cycloidLayer = CAShapeLayer()
    
    super.init(frame: frame)
    
    prepareView()
  }
  
  func beginAnimation() {
    CATransaction.begin()
    CATransaction.setAnimationDuration(3.0)
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.toValue   = 2 * M_PI * cycloid.numberOfRotations
    wheelLayer.addAnimation(animation, forKey: "rotation")

    let tranlation = CABasicAnimation(keyPath: "position.x")
    animation.toValue   = self.bounds.width
    wheelLayer.addAnimation(tranlation, forKey: "translation")
    
    CATransaction.commit()
  }
  
  
  func prepareView() {
    self.backgroundColor = UIColor.yellowColor().colorWithAlphaComponent(0.1)
    wheelLayer = createWheel()
    self.layer.addSublayer(wheelLayer)
    cycloidLayer = createCycloidLayer()
    self.layer.addSublayer(cycloidLayer)
  }
  
  
  func createWheel() -> CAShapeLayer {
    let wheel = CAShapeLayer()
    let radius = CGFloat(cycloid.radius)
    let wheelSize = radius * 2.0
    wheel.bounds = CGRect(x: 0, y: 0, width: wheelSize, height: wheelSize)
    wheel.position = CGPoint(x: 0, y: radius)
    
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: radius, y: radius))
    path.addLineToPoint(CGPoint(x: radius, y: wheelSize))
    path.addArcWithCenter(CGPoint(x: radius, y: radius), radius: radius,
              startAngle: CGFloat(M_PI_2), endAngle: CGFloat(5.0 * M_PI_2), clockwise: true)
    
    wheel.strokeColor = UIColor.blackColor().CGColor
    wheel.lineWidth = 2.0
    wheel.path = path.CGPath
    wheel.fillColor = UIColor.clearColor().CGColor
    
    return wheel
  }
  
  func createCycloidLayer() -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.bounds = self.bounds
    layer.position = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    layer.path = self.cycloid.bezierPath(100).CGPath
    layer.fillColor = UIColor.clearColor().CGColor
    layer.strokeColor = UIColor.blueColor().CGColor
    layer.lineWidth = 3.0
    
    return layer
  }
}

let view = AnimatingCycloidView(frame: CGRect(x: 0, y: 0, width: 700, height: 100))


XCPShowView("CycloidView", view)
view.beginAnimation()

let newAnim = CABasicAnimation(keyPath: "position.x")
newAnim.toValue = 200
newAnim.duration = 5
view.wheelLayer.addAnimation(newAnim, forKey: "position")






