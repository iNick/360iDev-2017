//
//  MainViewController.swift
//  BezierCurveDrawing
//
//  Created by Nick Dalton on 3/13/17.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

	var drawView: BezierPathDrawView?
	var drawViewTypes = [DrawViewType(name: "Straight Line", instance: StraightLinesDrawView()),
	                     DrawViewType(name: "Quad Bezier Curve", instance: QuadBezierCurveDrawView())]
	
	@IBOutlet weak var drawContainerView: UIView!
	@IBOutlet weak var linePatternStepper1: UIStepper!
	@IBOutlet weak var linePatternStepper2: UIStepper!
	@IBOutlet weak var linePatternValuesLabel: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		selectDrawView(0)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func selectDrawView(_ index: Int) {
		if index >= 0 && index < self.drawViewTypes.count {
			// Remove the current draw view
			if let drawView = self.drawView {
				drawView.removeFromSuperview()
			}
			
			// Add the new draw view
			if let drawView = self.drawViewTypes[index].instance {
				drawView.frame = self.drawContainerView.bounds
				self.drawContainerView.addSubview(drawView)
				drawView.setNeedsLayout()
				self.drawView = drawView
			}
		}
	}
	
	
	// MARK: - UITableViewDataSource

	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.drawViewTypes.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "DrawViewTypeCell", for: indexPath)
		
		let drawViewType = self.drawViewTypes[indexPath.row]
		
		cell.textLabel?.text = drawViewType.name
		
		if drawViewType.instance === self.drawView {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}

	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectDrawView(indexPath.row)
		tableView.reloadData()
	}

	
	// MARK: - Actions
	
	@IBAction func altitudeAngleSliderChanged(_ sender: UISlider) {
		self.drawView?.altitudeAngleMultiplier = CGFloat(sender.value)
	}
	
	@IBAction func coalescedTouchesSwitchChanged(_ sender: UISwitch) {
		self.drawView?.isCoalescedTouches = sender.isOn
	}
	
	@IBAction func linePatternStepperChanged(_ sender: UIStepper) {
		let linePatternString = "\(Int(self.linePatternStepper1.value)), \(Int(self.linePatternStepper2.value))"
		self.linePatternValuesLabel.text = linePatternString
		
		let onLength = CGFloat(self.linePatternStepper1.value)
		let offLength = CGFloat(self.linePatternStepper2.value)
		if onLength > 0.0 || offLength > 0.0 {
			let linePattern: [CGFloat] = [onLength, offLength]
			self.drawView?.linePattern = linePattern
		} else {
			self.drawView?.linePattern = nil
		}
	}

	@IBAction func lineWidthSliderChanged(_ sender: UISlider) {
		self.drawView?.userLineWidth = CGFloat(sender.value)
	}
	
	@IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
		self.drawView?.setNeedsDisplay()
	}
	
	@IBAction func predictedTouchesSwitchChanged(_ sender: UISwitch) {
		self.drawView?.isPredictedTouches = sender.isOn
	}
	
	@IBAction func showDrawRectSwitchChanged(_ sender: UISwitch) {
		self.drawView?.isShowDrawRect = sender.isOn
	}
	
	@IBAction func strokeTextureSwitchChanged(_ sender: UISwitch) {
		self.drawView?.isStrokeTexture = sender.isOn
	}

	@IBAction func stylusOnlySwitchChanged(_ sender: UISwitch) {
		self.drawView?.isStylusOnly = sender.isOn
	}
	
	@IBAction func touchForceSliderChanged(_ sender: UISlider) {
		self.drawView?.touchForceMultiplier = CGFloat(sender.value)
	}
	
	@IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {
		self.drawView?.removeAllPaths()
	}
	
	@IBAction func undoButtonTapped(_ sender: UIBarButtonItem) {
		self.drawView?.removeLastPath()
	}

}

