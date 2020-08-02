//
//  GamePadAnalogNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 09/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class GamepadAnalogChangedNotification {

	static let Name = Notification.Name("GamePadAnalogChangedNotification")

	let leftStickX:UInt16
	let leftStickY:UInt16
	let rightStickX:UInt16
	let rightStickY:UInt16
	let stickMax:UInt16
	let leftTrigger:UInt16
	let rightTrigger:UInt16
	let triggerMax:UInt16

	init(
		leftStickX:UInt16,
		leftStickY:UInt16,
		rightStickX:UInt16,
		rightStickY:UInt16,
		stickMax:UInt16,
		leftTrigger:UInt16,
		rightTrigger:UInt16,
		triggerMax:UInt16
	) {

		self.leftStickX = leftStickX
		self.leftStickY = leftStickY
		self.rightStickX = rightStickX
		self.rightStickY = rightStickY
		self.stickMax = stickMax
		self.leftTrigger = leftTrigger
		self.rightTrigger = rightTrigger
		self.triggerMax = triggerMax

	}

}
