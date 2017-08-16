//
//  StraightLinesDrawView.swift
//  BezierCurveDrawing
//
//  Created by Nick Dalton on 2/15/17.
//

import UIKit

class StraightLinesDrawView: BezierPathDrawView {

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		
		guard let touch = touches.first, shouldUseTouchEventForDrawing(touch) else {
			return
		}

		// Gather coalesced touches if enabled and available (iPad Pro only)
		var allTouches = [UITouch]()
		if self.isCoalescedTouches {
			if let coalescedTouches = event?.coalescedTouches(for: touch) {
				allTouches.append(contentsOf: coalescedTouches)
			} else {
				allTouches.append(touch)
			}
		} else {
			// Just add the single touch point
			allTouches.append(touch)
		}

		// Calculate rect to refresh
		let point = touch.location(in: self)
		var refreshRect = CGRect.zero
		if let previousPoint = currentPath()?.currentPoint, let lineWidth = currentPath()?.lineWidth {
			refreshRect = CGRect(p1: previousPoint, p2: point).insetBy(dx: -lineWidth, dy: -lineWidth)
		}

		// Add straight lines to path for each touch point
		for aTouch in allTouches {
			let point = aTouch.location(in: self)
			currentPath()?.addLine(to: point)
		}
		
		// Cause drawRect to be called for the calculated rect
		setNeedsDisplay(refreshRect)
	}

}
