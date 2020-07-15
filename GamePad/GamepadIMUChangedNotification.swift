//
//  GamePadIMUChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 15/07/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamepadIMUChangedNotification {

	static let Name = Notification.Name("GamePadIMUChangedNotification")

	let gyroPitch:Int32
	let gyroYaw:Int32
	let gyroRoll:Int32
	let accelX:Int32
	let accelY:Int32
	let accelZ:Int32

	init(
		gyroPitch:Int32,
		gyroYaw:Int32,
		gyroRoll:Int32,
		accelX:Int32,
		accelY:Int32,
		accelZ:Int32
	) {

		self.gyroPitch = gyroPitch
		self.gyroYaw = gyroYaw
		self.gyroRoll = gyroRoll
		self.accelX = accelX
		self.accelY = accelY
		self.accelZ = accelZ

	}

}
