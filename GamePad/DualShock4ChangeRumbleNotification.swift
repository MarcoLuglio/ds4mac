//
//  DualShock4ChangeRumbleNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class DualShock4ChangeRumbleNotification {

	static let Name = Notification.Name("DualShock4ChangeRumbleNotification")

	let leftHeavySlowRumble:UInt8
	let rightLightFastRumble:UInt8

	init(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8) {
		self.leftHeavySlowRumble = leftHeavySlowRumble
		self.rightLightFastRumble = rightLightFastRumble
	}

}
