//: Bezier Curves Playground
// 
// Advanced Drawing Techniques with UIBezierPath and Apple Pencil
// Presented by Nick Dalton at 360iDev on August 15, 2017
//
// Tested with Xcode 8.2.1
// 
// Open the Assistant Editor to see the liveView.

import UIKit
import PlaygroundSupport

class MyView : UIView {
    
  override func draw(_ rect: CGRect) {
    
    // Quadratic curve
    do {
      let startPoint   = CGPoint(x:  10, y: 200)
      let endPoint     = CGPoint(x: 290, y: 200)
      let controlPoint = CGPoint(x: 200, y:  50)
        
      let curve = UIBezierPath()
      curve.move(to: startPoint)
      curve.addQuadCurve(to: endPoint, controlPoint: controlPoint)
      curve.lineWidth = 5.0
      UIColor.blue.setStroke()
      curve.stroke()

      illustratePoints(start: startPoint, end: endPoint, controls: [controlPoint])
    }
    
    // Cubic curve
    do {
        let startPoint    = CGPoint(x:  10, y: 400)
        let endPoint      = CGPoint(x: 290, y: 400)
        let controlPoint1 = CGPoint(x:  10, y: 250)
        let controlPoint2 = CGPoint(x: 200, y: 450)

        let curve = UIBezierPath()
        curve.move(to: startPoint)
        curve.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        curve.lineWidth = 5.0
        UIColor.purple.setStroke()
        curve.stroke()
        
        illustratePoints(start: startPoint, end: endPoint, controls: [controlPoint1, controlPoint2])
    }
    
    // Two curves
    do {
      let startPointA    = CGPoint(x:  10, y: 600)
      let endPointA      = CGPoint(x: 150, y: 600)
      let controlPoint1A = CGPoint(x: 100, y: 700)
      let controlPoint2A = CGPoint(x:  50, y: 600)
      let endPointB      = CGPoint(x: 290, y: 600)
      let controlPoint1B = CGPoint(x: 200, y: 600)
      let controlPoint2B = CGPoint(x: 150, y: 500)
        
      let curve = UIBezierPath()
      curve.move(to: startPointA)
      curve.addCurve(to: endPointA, controlPoint1: controlPoint1A, controlPoint2: controlPoint2A)
      curve.addCurve(to: endPointB, controlPoint1: controlPoint1B, controlPoint2: controlPoint2B)
      curve.lineWidth = 5.0
      UIColor.brown.setStroke()
      curve.stroke()
        
      illustratePoints(start: startPointA, end: endPointA, controls: [controlPoint1A, controlPoint2A])
      illustratePoints(start: endPointA, end: endPointB, controls: [controlPoint1B, controlPoint2B])
    }
  }
    
  func illustratePoints(start: CGPoint, end: CGPoint, controls: [CGPoint]) {
    
    if controls.count > 0 {
      let linePath1 = UIBezierPath()
      linePath1.move(to: start)
      linePath1.addLine(to: controls.first!)
      UIColor.black.setStroke()
      linePath1.stroke()
        
      let linePath2 = UIBezierPath()
      linePath2.move(to: end)
      linePath2.addLine(to: controls.last!)
      UIColor.black.setStroke()
      linePath2.stroke()
    }
    
    let startPointPath = UIBezierPath()
    startPointPath.addArc(withCenter: start, radius: 3.0, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    startPointPath.lineWidth = 3.0
    UIColor.green.setStroke()
    startPointPath.stroke()
    
    for control in controls {
        let controlPointPath = UIBezierPath(rect: CGRect(origin: control, size: CGSize(width: 10.0, height: 10.0)).offsetBy(dx: -5.0, dy: -5.0))
        controlPointPath.lineWidth = 3.0
        UIColor.white.setFill()
        controlPointPath.fill()
        UIColor.black.setStroke()
        controlPointPath.stroke()
    }
    
    let endPointPath = UIBezierPath()
    endPointPath.addArc(withCenter: end, radius: 5.0, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    endPointPath.lineWidth = 3.0
    UIColor.red.setStroke()
    endPointPath.stroke()
  }
    
}


let myView = MyView(frame: CGRect(x: 0, y: 0, width: 300, height: 1000))
myView.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = myView
