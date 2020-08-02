//
//  Xbox360ChangeRumbleNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 13/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class XboxOneChangeRumbleNotification {

	static let Name = Notification.Name("XboxOneChangeRumbleNotification")

	let leftHeavySlowRumble:UInt8
	let rightLightFastRumble:UInt8
	let leftTriggerRumble:UInt8
	let rightTriggerRumble:UInt8

	init(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8, leftTriggerRumble:UInt8, rightTriggerRumble:UInt8) {
		self.leftHeavySlowRumble = leftHeavySlowRumble
		self.rightLightFastRumble = rightLightFastRumble
		self.leftTriggerRumble = leftTriggerRumble
		self.rightTriggerRumble = rightTriggerRumble
	}

}
