//
//  GamePadTouchpadChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 01/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class DualShock4TouchpadChangedNotification {

	static let Name = Notification.Name("DualShock4TouchpadChangedNotification")

	let touchpadTouch0IsActive:Bool
	let touchpadTouch0Id:UInt8
	let touchpadTouch0X:Int16 // 12 bits only
	let touchpadTouch0Y:Int16
	let touchpadTouch1IsActive:Bool
	let touchpadTouch1Id:UInt8
	let touchpadTouch1X:Int16 // 12 bits only
	let touchpadTouch1Y:Int16

	init(
		touchpadTouch0IsActive:Bool,
		touchpadTouch0Id:UInt8,
		touchpadTouch0X:Int16,
		touchpadTouch0Y:Int16,
		touchpadTouch1IsActive:Bool,
		touchpadTouch1Id:UInt8,
		touchpadTouch1X:Int16,
		touchpadTouch1Y:Int16
	) {

		self.touchpadTouch0IsActive = touchpadTouch0IsActive
		self.touchpadTouch0Id = touchpadTouch0Id
		self.touchpadTouch0X = touchpadTouch0X
		self.touchpadTouch0Y = touchpadTouch0Y
		self.touchpadTouch1IsActive = touchpadTouch1IsActive
		self.touchpadTouch1Id = touchpadTouch1Id
		self.touchpadTouch1X = touchpadTouch1X
		self.touchpadTouch1Y = touchpadTouch1Y

	}

}
