//
//  CGRectExtensions.swift
//  BezierCurveDrawing
//
//  Created by Nick Dalton on 2/17/17.
//

import CoreGraphics

extension CGRect {
	
	public init(p1: CGPoint, p2: CGPoint) {
		let rawRect = CGRect(x: p1.x, y: p1.y, width: p2.x - p1.x, height: p2.y - p1.y)
		let standardizedRect = rawRect.standardized
		self = standardizedRect
	}

	public init(p1: CGPoint, p2: CGPoint, p3: CGPoint) {
		let rect1 = CGRect(x: p1.x, y: p1.y, width: p2.x - p1.x, height: p2.y - p1.y)
		if rect1.contains(p3) {
			self = rect1.standardized
		} else {
			let rect2 = CGRect(x: p1.x, y: p1.y, width: p3.x - p1.x, height: p3.y - p1.y)
			let unionRect = rect1.union(rect2)
			self = unionRect.standardized
		}
	}
	
	public init(rect: CGRect, includePoint: CGPoint) {
		if rect.contains(includePoint) {
			self = rect.standardized
		} else {
			let rect2 = CGRect(origin: rect.origin, size: CGSize(width: includePoint.x - rect.origin.x, height: includePoint.y - rect.origin.y))
			let unionRect = rect.union(rect2)
			self = unionRect.standardized
		}
	}
	
}
