//
//  GamePadBatteryChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamePadBatteryChangedNotification {

	static let Name = Notification.Name("GamePadBatteryChangedNotification")

	let battery:UInt8
	let batteryMin:UInt8
	let batteryMax:UInt8

	init(
		battery:UInt8,
		batteryMin:UInt8,
		batteryMax:UInt8
	) {

		self.battery = battery
		self.batteryMin = batteryMin
		self.batteryMax = batteryMax

	}

}
