//
//  DualShock4ChangeLedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class JoyConChangeLedNotification {

	static let Name = Notification.Name("JoyConChangeLedNotification")

	var led1On = false
	var led2On = false
	var led3On = false
	var led4On = false

	/// On overrides flashing
	init(
		led1On = false,
		led2On = false,
		led3On = false,
		led4On = false,

	) {
		//
	}

}
