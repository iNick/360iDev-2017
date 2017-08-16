//: Smooth Curves Playground
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
        
    let p0 = CGPoint(x:  25, y: 100)
    let p1 = CGPoint(x:  75, y:  10)
    let p2 = CGPoint(x: 125, y:  50)
    let p3 = CGPoint(x: 175, y: 150)
    let p4 = CGPoint(x: 225, y: 100)
    let p5 = CGPoint(x: 275, y: 100)
    
    // Straight lines
    let straightPath = UIBezierPath()
    straightPath.move(to: p0)
    straightPath.addLine(to: p1)
    straightPath.addLine(to: p2)
    straightPath.addLine(to: p3)
    straightPath.addLine(to: p4)
    straightPath.addLine(to: p5)
    straightPath.lineWidth = 5.0
    UIColor.lightGray.setStroke()
    straightPath.stroke()
    
    
    // Smooth quad curves
    let quadPath = UIBezierPath()
    quadPath.move(to: p0)
    
    let m13 = CGPoint(x: (p1.x + p3.x) / 2.0, y: (p1.y + p3.y) / 2.0)
    quadPath.addQuadCurve(to: m13, controlPoint: p1)
    illustratePoints(start: p0, end: m13, controls: [p1])

    let m35 = CGPoint(x: (p3.x + p5.x) / 2.0, y: (p3.y + p5.y) / 2.0)
    quadPath.addQuadCurve(to: m35, controlPoint: p3)
    illustratePoints(start: m13, end: m35, controls: [p3])

    quadPath.addLine(to: p5)

    quadPath.lineWidth = 5.0
    UIColor.blue.setStroke()
    quadPath.stroke()

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
