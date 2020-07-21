//
//  Xbox360UIModel.swift
//  GamePad
//
//  Created by Marco Luglio on 15/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import Combine



class JoyConUIModel: ObservableObject {

	var leftTrigger:Float = 0
	var leftTriggerButton = false
	var leftShoulderButton = false

	var minusButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0

	var leftSideTopButton = false

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var captureButton = false

	var leftSideBottomButton = false
	var rightSideBottomButton = false

	var homeButton = false

	var rightStickX:Float = 0
	var rightStickY:Float = 0
	var rightStickButton = false

	var rightSideTopButton = false

	var xButton = false
	var aButton = false
	var bButton = false
	var yButton = false

	var plusButton = false

	var rightShoulderButton = false
	var rightTriggerButton = false
	var rightTrigger:Float = 0

	let objectWillChange = ObservableObjectPublisher()

	init() {

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateButtons),
				name: GamepadButtonChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateAnalog),
				name: GamepadAnalogChangedNotification.Name,
				object: nil
			)

	}

	@objc func updateButtons(_ notification:Notification) {

		let o = notification.object as! GamepadButtonChangedNotification

		self.leftTriggerButton = o.leftTriggerButton
		self.leftShoulderButton = o.leftShoulderButton
		self.minusButton = o.minusButton
		self.leftStickButton = o.leftStickButton
		self.leftSideTopButton = o.leftSideTopButton
		self.upButton = o.upButton
		self.rightButton = o.rightButton
		self.downButton = o.downButton
		self.leftButton = o.leftButton
		self.captureButton = o.socialButton
		self.leftSideBottomButton = o.leftSideBottomButton
		self.rightSideBottomButton = o.rightSideBottomButton
		self.homeButton = o.rightAuxiliaryButton
		self.rightStickButton = o.rightStickButton
		self.rightSideTopButton = o.rightSideTopButton
		self.xButton = o.faceNorthButton
		self.aButton = o.faceEastButton
		self.bButton = o.faceSouthButton
		self.yButton = o.faceWestButton
		self.plusButton = o.plusButton
		self.rightShoulderButton = o.rightShoulderButton
		self.rightTriggerButton = o.rightTriggerButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamepadAnalogChangedNotification

		self.leftTrigger = Float(o.leftTrigger)

		self.leftStickX = Float(o.leftStickX)
		self.leftStickY = Float(o.leftStickY)

		self.rightStickX = Float(o.rightStickX)
		self.rightStickY = Float(o.rightStickY)

		self.rightTrigger = Float(o.rightTrigger)

		objectWillChange.send()

	}

}
