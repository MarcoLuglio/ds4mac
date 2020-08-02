//
//  DualShock4ChangeLedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class DualShock4ChangeLedNotification {

	static let Name = Notification.Name("DualShock4ChangeLedNotification")

	let red:CGFloat
	let green:CGFloat
	let blue:CGFloat

	init(red:CGFloat, green:CGFloat, blue:CGFloat) {
		self.red = red
		self.green = green
		self.blue = blue
	}

}
