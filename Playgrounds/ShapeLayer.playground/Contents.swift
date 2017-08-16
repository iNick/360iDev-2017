//: ShapeLayer Playground
//
// Advanced Drawing Techniques with UIBezierPath and Apple Pencil
// Presented by Nick Dalton at 360iDev on August 15, 2017
//
// Tested with Xcode 8.2.1
//
// Open the Assistant Editor to see the liveView.

import UIKit
import PlaygroundSupport

// Helper functions
func animation(keyPath: String, duration: CFTimeInterval) -> CAAnimation {
	let strokeEndAnimation = CABasicAnimation(keyPath: keyPath)
	strokeEndAnimation.duration = duration
	strokeEndAnimation.fillMode = kCAFillModeForwards
	strokeEndAnimation.isRemovedOnCompletion = false
	strokeEndAnimation.toValue = 1.0
	return strokeEndAnimation
}


let myView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 1000))
myView.backgroundColor = UIColor.white


// Rounded rect
do {
  let roundedRectPath = UIBezierPath(roundedRect: CGRect(x: 10, y: 10, width: 100, height: 100), cornerRadius: 20.0)
    
  let shapeLayer1 = CAShapeLayer()
  shapeLayer1.path = roundedRectPath.cgPath
  shapeLayer1.lineWidth = 5.0
  shapeLayer1.fillColor = UIColor.yellow.cgColor
  shapeLayer1.strokeColor = UIColor.blue.cgColor
  myView.layer.addSublayer(shapeLayer1)
}

// Animated line
do {
  let linePath = UIBezierPath()
  linePath.move(to: CGPoint(x: 10, y: 200))
  linePath.addLine(to: CGPoint(x: 290, y: 200))

  let shapeLayer2 = CAShapeLayer()
  shapeLayer2.path = linePath.cgPath
  shapeLayer2.lineWidth = 5.0
  shapeLayer2.strokeColor = UIColor.red.cgColor
  shapeLayer2.strokeStart = 0.0
  shapeLayer2.strokeEnd = 0.0
  shapeLayer2.add(animation(keyPath: "strokeEnd", duration: 5.0), forKey: nil)
  myView.layer.addSublayer(shapeLayer2)
}

PlaygroundPage.current.liveView = myView
