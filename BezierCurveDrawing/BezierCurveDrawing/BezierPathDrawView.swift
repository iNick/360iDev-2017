//
//  BezierPathDrawView.swift
//  BezierCurveDrawing
//
//  Created by Nick Dalton on 2/15/17.
//

import UIKit


class BezierPathDrawView: UIView {
	
	var altitudeAngleMultiplier = CGFloat(0.0)
	var currentPathIndex = -1
	var isCoalescedTouches = false
	var isPredictedTouches = false
	var isShowDrawRect = false
	var isStrokeTexture = false
	var isStylusOnly = false
	var linePattern: [CGFloat]?
	var lineWidth = CGFloat(2.0)
	var paths = [UIBezierPath]()
	var predictedPath: UIBezierPath? {
		didSet {
			let lineWidth = currentPath()?.lineWidth ?? self.lineWidth
			// Clear previous path area
			if oldValue != nil {
				setNeedsDisplay(oldValue!.bounds.insetBy(dx: -lineWidth, dy: -lineWidth))
			}
			// Update new path area
			if predictedPath != nil {
				setNeedsDisplay(predictedPath!.bounds.insetBy(dx: -lineWidth, dy: -lineWidth))
			}
		}
	}
	var texture = UIColor(patternImage: #imageLiteral(resourceName: "PencilTexture"))
	var touchForceMultiplier = CGFloat(0.0)
	var userLineWidth = CGFloat(2.0)
	

	// MARK: Init
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		commonInit()
	}
	
	func commonInit() {
		self.backgroundColor = UIColor.white
		self.isMultipleTouchEnabled = false
	}
	
	
	// MARK: - Path management
	
	func currentPath() -> UIBezierPath? {
		if self.currentPathIndex >= 0 && self.currentPathIndex < self.paths.count {
			return self.paths[self.currentPathIndex]
		} else {
			return nil
		}
	}
	
	func newPath() -> UIBezierPath? {
		let path = UIBezierPath()
		path.lineWidth = self.lineWidth
		self.paths.append(path)
		
		self.currentPathIndex += 1
		
		return path
	}
	
	func addPath(_ path: UIBezierPath) {
		self.paths.append(path)
		self.currentPathIndex += 1
	}
	
	func removeAllPaths() {
		// Remove all paths
		self.paths.removeAll()
		self.currentPathIndex = -1
		
		// Refresh the entire display
		setNeedsDisplay()
	}
	
	func removeLastPath() {
		if self.paths.count > 0 {
			// Get the rect of the last path
			var refreshRect = self.bounds
			if let lastPath = self.paths.last {
				// Add lineWidth to the rect to include edges of the path
				refreshRect = lastPath.bounds.insetBy(dx: -self.lineWidth, dy: -self.lineWidth)
			}
			
			// Remove the path
			self.paths.removeLast()
			self.currentPathIndex -= 1

			// Refresh the rect of the screen where the last path was
			setNeedsDisplay(refreshRect)
		}
	}
	
	
	// MARK: - Drawing
	
    override func draw(_ rect: CGRect) {
		// Show the rect that is being drawn
		if self.isShowDrawRect {
			if let context = UIGraphicsGetCurrentContext() {
				context.setStrokeColor(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1).cgColor)
				context.stroke(rect)
			}
		}

		// Set stroke as a solid color or a texture
		if self.isStrokeTexture {
			self.texture.setStroke()
		} else {
			#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).setStroke()
		}
		
		// Draw each path
		for path in self.paths {
			path.lineCapStyle = .round
			
			// Set pattern for a dashed line
			if let linePattern = self.linePattern {
				path.setLineDash(linePattern, count: linePattern.count, phase: 0.0)
			}
			
			path.stroke()
		}
		
		// Draw predicted path
		if let predictedPath = self.predictedPath {
			#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1).setStroke()
			predictedPath.lineCapStyle = .round
			predictedPath.stroke()
		}
	}
	
	
	// MARK: - Touches
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
		guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
			return
		}
		
		let point = touch.location(in: self)
		self.newPath()?.move(to: point)
		
		// Adjust the line width using the stylus altitude angle
		if touch.altitudeAngle < .pi / 2.0 && self.altitudeAngleMultiplier > 0.0 {
			let altitude = (.pi / 2.0 - touch.altitudeAngle) / .pi / 2.0
			let altitudeLineWidth = altitude * self.altitudeAngleMultiplier
			self.lineWidth = altitudeLineWidth
		} else {
			// No stylus
			self.lineWidth = self.userLineWidth
		}
		
		self.currentPath()?.lineWidth = self.lineWidth
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
			return
		}
		
		// Adjust the line width using the stylus touch force (Apple Pencil only)
		if touch.force > 0.0  && self.touchForceMultiplier > 0 {
			let forceLineWidth = touch.force * self.touchForceMultiplier
			self.currentPath()?.lineWidth = forceLineWidth
			self.lineWidth = forceLineWidth
			self.setNeedsDisplay()
		} else {
			// No stylus
			self.lineWidth = self.userLineWidth
		}
		
		// Draw predicted path if enabled and available (iPad Pro only)
		if self.isPredictedTouches {
			if let predictedTouches = event?.predictedTouches(for: touch), predictedTouches.count > 0 {
				let predictedPath = UIBezierPath()
				predictedPath.lineWidth = self.lineWidth
				predictedPath.move(to: touch.location(in: self))
				
				for aTouch in predictedTouches {
					let point = aTouch.location(in: self)
					predictedPath.addLine(to: point)
				}
				
				self.predictedPath = predictedPath
			} else {
				self.predictedPath = nil
			}
		}
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		
		// Discard any predicted path when touches have ended.
		self.predictedPath = nil
	}
	

	func shouldUseTouchEventForDrawing(_ touch: UITouch) -> Bool {
		if self.isStylusOnly {
			if touch.type == .stylus {
				// Only use stylus touch events
				return true
			} else {
				// Reject all other touch events
				return false
			}
		} else {
			// Accept all touch events
			return true
		}
	}
	
}
