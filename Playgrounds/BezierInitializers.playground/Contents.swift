//: Bezier Initializers Playground
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

    // Straight lines
    let linesPath = UIBezierPath()
    linesPath.move(to: CGPoint(x: 10, y: 10))
    linesPath.addLine(to: CGPoint(x: 50, y: 100))
    linesPath.addLine(to: CGPoint(x: 200, y: 50))
    linesPath.close()
    linesPath.lineWidth = 5.0
    UIColor.blue.setStroke()
    linesPath.stroke()

    // Rectangle
    let rectPath = UIBezierPath.init(rect: CGRect(x: 10, y: 150, width: 200, height: 50))
    rectPath.lineWidth = 5.0
    UIColor.purple.setStroke()
    rectPath.stroke()
    
    // Rounded rectangle
    let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: 10, y: 250, width: 100, height: 100), cornerRadius: 20.0)
    roundedRectPath.lineWidth = 5.0
    // Fill the path before stroking it so that the fill colore does not obscure the stroked line
    UIColor.yellow.setFill()
    roundedRectPath.fill()
    UIColor.red.setStroke()
    roundedRectPath.stroke()
    
    // Circle
    let circlePath = UIBezierPath(arcCenter: CGPoint(x: 60, y: 450), radius: 50.0, startAngle: 0.0, endAngle: CGFloat(.pi * 2.0), clockwise: true)
    circlePath.lineWidth = 5.0
    UIColor.brown.setStroke()
    circlePath.stroke()
    
    // Oval
    let ovalPath = UIBezierPath(ovalIn: CGRect(x: 10, y: 550, width: 200, height: 50))
    ovalPath.lineWidth = 5.0
    UIColor.purple.setStroke()
    ovalPath.stroke()
    
    // Dashed line
    let lineDashPath1 = UIBezierPath()
    lineDashPath1.move(to: CGPoint(x: 10, y: 650))
    lineDashPath1.addLine(to: CGPoint(x: 250, y: 650))
    lineDashPath1.lineWidth = 5.0
    let linePattern1: [CGFloat] = [20.0, 10.0]
    lineDashPath1.setLineDash(linePattern1, count: linePattern1.count, phase: 0.0)
    UIColor.blue.setStroke()
    lineDashPath1.stroke()
    
    // Dotted line
    lineDashPath1.apply(CGAffineTransform.init(translationX: 0.0, y: 30.0))
    let linePattern2: [CGFloat] = [0.0, 10.0]
    lineDashPath1.setLineDash(linePattern2, count: linePattern2.count, phase: 0.0)
    lineDashPath1.lineCapStyle = .round
    lineDashPath1.stroke()
    
    // This code is perfectly valid but the Playground shows this ugly warning message when the UIColor(patternImage:) method is called
    // -[NSKeyedArchiver dealloc]: warning: NSKeyedArchiver deallocated without having had -finishEncoding called on it.
	/*
    // Line with a pattern
    if let patternImage = UIImage(named: "PencilTexture.png") {
        let pattern1 = UIColor(patternImage: patternImage)
        let linePatternPath1 = UIBezierPath()
        linePatternPath1.move(to: CGPoint(x: 20, y: 750))
        linePatternPath1.addLine(to: CGPoint(x: 250, y: 750))
        linePatternPath1.lineWidth = 20.0
        linePatternPath1.lineCapStyle = .round
        pattern1.setStroke()
        linePatternPath1.stroke()
    }
	*/
  }
    
}


let myView = MyView(frame: CGRect(x: 0, y: 0, width: 300, height: 1000))
myView.backgroundColor = UIColor.white
PlaygroundPage.current.liveView = myView
