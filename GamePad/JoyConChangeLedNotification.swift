//
//  DualShock4ChangeLedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class JoyConChangeLedNotification {

	static let Name = Notification.Name("JoyConChangeLedNotification")

	var led1On = false
	var led2On = false
	var led3On = false
	var led4On = false
	var blinkLed1 = false
	var blinkLed2 = false
	var blinkLed3 = false
	var blinkLed4 = false

	/// On overrides flashing
	init(
		led1On:Bool = false,
		led2On:Bool = false,
		led3On:Bool = false,
		led4On:Bool = false,
		blinkLed1:Bool = false,
		blinkLed2:Bool = false,
		blinkLed3:Bool = false,
		blinkLed4:Bool = false
	) {

		self.led1On = led1On
		self.led2On = led1On
		self.led3On = led1On
		self.led4On = led1On

		if !self.led1On {
			self.blinkLed1 = blinkLed1
		}

		if !self.led2On {
			self.blinkLed2 = blinkLed2
		}

		if !self.led3On {
			self.blinkLed3 = blinkLed3
		}

		if !self.led4On {
			self.blinkLed4 = blinkLed4
		}

	}

}
