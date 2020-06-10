//
//  GamePadAnalogNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 09/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamePadAnalogChangedNotification {

	static let Name = Notification.Name("GamePadAnalogChangedNotification")

	let leftStickX:UInt8
	let leftStickY:UInt8
	let rightStickX:UInt8
	let rightStickY:UInt8
	let leftTrigger:UInt8
	let rightTrigger:UInt8

	init(
		leftStickX:UInt8,
		leftStickY:UInt8,
		rightStickX:UInt8,
		rightStickY:UInt8,
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
