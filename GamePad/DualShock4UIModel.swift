//
//  DualShock4UIModel.swift
//  GamePad
//
//  Created by Marco Luglio on 09/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import Combine



class DualShock4UIModel: ObservableObject {

	var leftTrigger:Float = 0
	var leftShoulderButton = false

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var shareButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0
	// TODO trackpad touches
	var trackPadButton = false
	var psButton = false

	var rightStickX:Float = 0
	var rightStickY:Float = 0
	var rightStickButton = false

	var optionsButton = false

	var triangleButton = false
	var circleButton = false
	var crossButton = false
	var squareButton = false

	var rightShoulderButton = false
	var rightTrigger:Float = 0

	var battery:Float = 0

	let objectWillChange = ObservableObjectPublisher()

	init() {

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateButtons),
				name: GamePadButtonChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateAnalog),
				name: GamePadAnalogChangedNotification.Name,
				object: nil
			)

		// TODO trackpad

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateBattery),
				name: GamePadBatteryChangedNotification.Name,
				object: nil
			)

	}

	@objc func updateButtons(_ notification:Notification) {

		let o = notification.object as! GamePadButtonChangedNotification

		self.leftShoulderButton = o.leftShoulderButton
		self.upButton = o.upButton
		self.rightButton = o.rightButton
		self.downButton = o.downButton
		self.leftButton = o.leftButton
		self.shareButton = o.shareButton
		self.leftStickButton = o.leftStickButton
		self.trackPadButton = o.trackPadButton
		self.psButton = o.psButton
		self.rightStickButton = o.rightStickButton
		self.optionsButton = o.optionsButton
		self.triangleButton = o.triangleButton
		self.circleButton = o.circleButton
		self.crossButton = o.crossButton
		self.squareButton = o.squareButton
		self.rightShoulderButton = o.rightShoulderButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamePadAnalogChangedNotification

		self.leftTrigger = Float(o.leftTrigger)

		self.leftStickX = Float(o.leftStickX)
		self.leftStickY = Float(o.leftStickY)

		self.rightStickX = Float(o.rightStickX)
		self.rightStickY = Float(o.rightStickY)

		self.rightTrigger = Float(o.rightTrigger)

		objectWillChange.send()

	}

	@objc func updateBattery(_ notification:Notification) {

		let o = notification.object as! GamePadBatteryChangedNotification

		self.battery = Float(o.battery)

		objectWillChange.send()

	}

}
