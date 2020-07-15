//
//  GamePadAnalogNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 09/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamepadAnalogChangedNotification {

	static let Name = Notification.Name("GamePadAnalogChangedNotification")

	let leftStickX:Int16
	let leftStickY:Int16
	let rightStickX:Int16
	let rightStickY:Int16
	let leftTrigger:UInt8
	let rightTrigger:UInt8

	init(
		leftStickX:Int16,
		leftStickY:Int16,
		rightStickX:Int16,
		rightStickY:Int16,
		leftTrigger:UInt8,
		rightTrigger:UInt8
	) {

		self.leftStickX = leftStickX
		self.leftStickY = leftStickY
		self.rightStickX = rightStickX
		self.rightStickY = rightStickY
		self.leftTrigger = leftTrigger
		self.rightTrigger = rightTrigger

	}

}
