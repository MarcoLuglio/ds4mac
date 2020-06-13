//
//  Xbox360ChangeRumbleNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 13/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class Xbox360ChangeRumbleNotification {

	static let Name = Notification.Name("Xbox360ChangeRumbleNotification")

	let leftHeavySlowRumble:UInt8
	let rightLightFastRumble:UInt8

	init(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8) {
		self.leftHeavySlowRumble = leftHeavySlowRumble
		self.rightLightFastRumble = rightLightFastRumble
	}

}
