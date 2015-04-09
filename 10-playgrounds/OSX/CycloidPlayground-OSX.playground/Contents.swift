import Cocoa
import QuartzCore
import XCPlayground

extension NSBezierPath {
  var CGPath: CGPathRef! {
  get {
    if self.elementCount == 0 {
      return nil
    }
    
    let path = CGPathCreateMutable()
    
    for i in 0..<self.elementCount {
      var points = [NSPoint](count: 3, repeatedValue: NSZeroPoint)
      
      switch self.elementAtIndex(i, associatedPoints: &points) {
      case .MoveToBezierPathElement:CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
      case .LineToBezierPathElement:CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
      case .CurveToBezierPathElement:CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
      case .ClosePathBezierPathElement:CGPathCloseSubpath(path)
      }
    }
    return CGPathCreateCopy(path)
  }
  }
}


let radius = 10.0

for circleProp in 1...100 {
  let alpha = Double(circleProp) / 100.0 * 2.0 * M_PI
  let y = radius * (1 - cos(alpha))
  let x = radius * (alpha - sin(alpha))
}


class Cycloid: NSObject {
  private let radius: Double
  private let numberOfRotations: Double
  
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
  
  func bezierPath(numberSamples: UInt) -> NSBezierPath {
    let bezierPath = NSBezierPath()
    bezierPath.moveToPoint(CGPoint.zeroPoint)
    for point in pointsForCycloid(numberSamples) {
      bezierPath.lineToPoint(point)
    }
    return bezierPath
  }
  
  func debugQuickLookObject() -> AnyObject? {
    return bezierPath(100)
  }
}

let c = Cycloid(radius: 50, numberOfRotations: 3)



class AnimatingCycloidView: NSView {
  private let cycloid: Cycloid
  private var wheelLayer = CAShapeLayer()
  private var cycloidLayer = CAShapeLayer()
  
  override init(frame: CGRect) {
    let radius: Double = Double(frame.height) / 2.0
    let numberOfRotations: Double = Double(frame.width) / (2.0 * M_PI * radius)
    cycloid = Cycloid(radius: radius, numberOfRotations: numberOfRotations)
    
    super.init(frame: frame)
    
    self.wantsLayer = true
    
    prepareView()
  }

  required init?(coder: NSCoder) {
    cycloid = Cycloid(radius: 10, numberOfRotations: 10)
    super.init(coder: coder)
  }
  
  
  func beginAnimation() {
    self.wheelLayer.setValue(-2 * M_PI * self.cycloid.numberOfRotations, forKeyPath: "transform.rotation.z")
    self.wheelLayer.setValue(self.bounds.width, forKeyPath: "position.x")
    self.cycloidLayer.strokeEnd = 1.0
    
    CATransaction.begin()
    CATransaction.setAnimationDuration(6.0)
    
    let animation = CABasicAnimation(keyPath: "transform.rotation.z")
    animation.fromValue = 0
    animation.toValue   = -2 * M_PI * cycloid.numberOfRotations
    
    let translation = CABasicAnimation(keyPath: "position.x")
    translation.fromValue = 0
    translation.toValue   = self.bounds.width
    
    let animationGroup = CAAnimationGroup()
    animationGroup.animations = [animation, translation]
    animationGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    animationGroup.removedOnCompletion = false
    
    wheelLayer.addAnimation(animationGroup, forKey: "wheelSpin")
    
    CATransaction.commit()
  }
  
  
  func prepareView() {
    wheelLayer = createWheel()
    self.layer?.addSublayer(wheelLayer)
    cycloidLayer = createCycloidLayer()
    self.layer?.addSublayer(cycloidLayer)
  }
  
  
  func createWheel() -> CAShapeLayer {
    let wheel = CAShapeLayer()
    let radius = CGFloat(cycloid.radius)
    let wheelSize = radius * 2.0
    wheel.bounds = CGRect(x: 0, y: 0, width: wheelSize, height: wheelSize)
    wheel.position = CGPoint(x: 0, y: radius)
    
    let path = NSBezierPath()
    path.moveToPoint(CGPoint(x: radius, y: 0))
    path.lineToPoint(CGPoint(x: radius, y: radius))
    path.appendBezierPathWithOvalInRect(wheel.bounds)
    
    wheel.strokeColor = NSColor.blackColor().CGColor
    wheel.lineWidth = 2.0
    wheel.path = path.CGPath
    wheel.fillColor = NSColor.clearColor().CGColor
    
    return wheel
  }
  
  func createCycloidLayer() -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.bounds = self.bounds
    layer.position = CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    layer.path = self.cycloid.bezierPath(100).CGPath
    layer.fillColor = NSColor.clearColor().CGColor
    layer.strokeColor = NSColor.blueColor().CGColor
    layer.lineWidth = 3.0
    
    return layer
  }
}

let view = AnimatingCycloidView(frame: CGRect(x: 0, y: 0, width: 700, height: 100))

XCPShowView("CycloidView", view)
view.beginAnimation()






