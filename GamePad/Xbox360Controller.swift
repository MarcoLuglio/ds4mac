//
//  Xbox360Controller.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class Xbox360Controller {

	static let VENDOR_ID_MICROSOFT:Int64 = 0x045E // 1118
	static let CONTROLLER_ID_XBOX_360:Int64 = 0x028E // 654
	// 0x028F is the wireless version
	// 0x02D1 is the xbox one controller
	// 0x02DD Xbox One Controller (Firmware 2015)
	// 0x02E3 Xbox One Elite Controller
	// 0x02E6 Wireless XBox Controller Dongle
	// 0x02EA Xbox One S Controller
	// 0x02FD Xbox One S Controller [Bluetooth]

	static var nextId:UInt8 = 0

	let device:IOHIDDevice

	var id:UInt8 = 0

	/// contains a, b, x, y, shoulder and xbox buttons
	var mainButtons:UInt8 = 0
	var previousMainButtons:UInt8 = 0

	// top button
	var yButton:Bool = false
	var previousYButton:Bool = false

	// right button
	var bButton:Bool = false
	var previousBButton:Bool = false

	// bottom button
	var aButton:Bool = false
	var previousAButton:Bool = false

	// left button
	var xButton:Bool = false
	var previousXButton:Bool = false

	// shoulder buttons
	var leftShoulderButton:Bool = false
	var previousLeftShoulderButton:Bool = false
	var rightShoulderButton:Bool = false
	var previousRightShoulderButton:Bool = false
	var leftTriggerButton:Bool = false // adding for compatibility, the report only has analog data
	var previousLeftTriggerButton:Bool = false
	var rightTriggerButton:Bool = false  // adding for compatibility, the report only has analog data
	var previousRightTriggerButton:Bool = false

	/// contains start, back, thumbstick buttons and directionla pad
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	// thumbstick buttons
	var leftStickButton:Bool = false
	var previousLeftStickButton:Bool = false
	var rightStickButton:Bool = false
	var previousRightStickButton:Bool = false

	// other buttons

	var backButton:Bool = false
	var previousBackButton:Bool = false
	var startButton:Bool = false
	var previousStartButton:Bool = false

	var xboxButton:Bool = false
	var previousXboxButton:Bool = false

	// analog buttons

	var leftStickX:UInt16 = 0
	var leftStickY:UInt16 = 0
	var rightStickX:UInt16 = 0
	var rightStickY:UInt16 = 0
	var leftTrigger:UInt8 = 0
	var rightTrigger:UInt8 = 0

	// battery ??

	init(_ device:IOHIDDevice) {

		self.id = Xbox360Controller.nextId
		Xbox360Controller.nextId = Xbox360Controller.nextId + 1

		self.device = device
		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		self.sendReport()

	}

	func parseReport(_ report:Data) {

		// report[0] // always 0x00
		// report[1] // always 0x14

		self.mainButtons = report[3]

		self.yButton             = mainButtons & 0b10000000 == 0b10000000
		self.xButton             = mainButtons & 0b01000000 == 0b01000000
		self.bButton             = mainButtons & 0b00100000 == 0b00100000
		self.aButton             = mainButtons & 0b00010000 == 0b00010000

		// no 0b00001000, reserved for the new upload button maybe??

		self.xboxButton          = mainButtons & 0b00000100 == 0b00000100
		self.rightShoulderButton = mainButtons & 0b00000010 == 0b00000010
		self.leftShoulderButton  = mainButtons & 0b00000001 == 0b00000001

		self.secondaryButtons = report[2]

		self.startButton      = secondaryButtons & 0b00010000 == 0b00010000
		self.backButton       = secondaryButtons & 0b00100000 == 0b00100000
		self.leftStickButton  = secondaryButtons & 0b01000000 == 0b01000000
		self.rightStickButton = secondaryButtons & 0b10000000 == 0b10000000

		/*
		0x00000001 	D-pad up
		0x00000010 	D-pad down
		0x00000100 	D-pad left
		0x00001000 	D-pad right
		*/
		self.directionalPad   = secondaryButtons & 0b00001111

		// analog buttons
		// origin?
		self.leftStickX = UInt16(report[6] << 8) | UInt16(report[7]) // 0 left?
		self.leftStickY = UInt16(report[8] << 8) | UInt16(report[9]) // 0 up?
		self.rightStickX = UInt16(report[10] << 8) | UInt16(report[11])
		self.rightStickY = UInt16(report[12] << 8) | UInt16(report[13])
		self.leftTrigger = report[4] // 0 - 65535
		self.rightTrigger = report[5] // 0 - 65535

		// print(self.leftStickX) // got the sign wrong
		// print(self.leftStickY) // when i pull up is conts down, when I pull down it is ok

		/*
		00 14 tt tt xx yy aa aa aa aa bb bb bb bb 00 00 00 00 00 00

		a is the left hat,
		b is the right hat
		*/

	}

	private func sendReport() {

		/*
		message of the following form:

		0103xx
		0x01 is the message type
		0x03 is the message length
		0xXX is the desired pattern:

		Where xx is the desired pattern:

		0x00 0b00000000 All off
		0x01 0b00000001 All blinking
		0x02 0b00000010 1 flashes, then on
		0x03 0b00000011 2 flashes, then on
		0x04 0b00000100 3 flashes, then on
		0x05 0b00000101 4 flashes, then on
		0x06 0b00000110 1 on
		0x07 0b00000111 2 on
		0x08 0b00001000	3 on
		0x09 0b00001001	4 on
		0x0A 0b00001010	Rotating (e.g. 1-2-4-3)

		can it be combined with two messages?
		0x0B 0b00000111 Blinking*
		0x0C 0b00001100	Slow blinking*
		0x0D 0b00001101	Alternating (e.g. 1+4-2+3), then back to previous

		0x0E 0b00001110 At start it sends this, is it to reset/disable everything?
		*/



		let xbox360ControllerInputReport:[UInt8] = [0x01, 0x03, 0x02]
		let xbox360ControllerInputReportLength = xbox360ControllerInputReport.count
		//let pointer = unsafeBitCast(xbox360ControllerInputReport, to: UnsafePointer<Any>.self)

		/*IOHIDDeviceSetReportWithCallback(
			device,
			kIOHIDReportTypeInput,
			1,
			unsafeBitCast(xbox360ControllerInputReport, to: UnsafePointer.self),
			xbox360ControllerInputReportLength,
			500, // timeout in what?? ms
			{() in
				//
			},
			hidContext
		)*/

		IOHIDDeviceSetReport(
			self.device,
			kIOHIDReportTypeOutput,
			0x01,
			xbox360ControllerInputReport,
			xbox360ControllerInputReportLength
		)

		/*
		Rumbling is also similar to on the original controller. Rumble commands take the following form:
		00 08 00 bb ll 00 00 00
		Where b is the speed to set the motor with the big weight
		and l is the speed to set the small weight
		(0x00 to 0xFF in both cases).
		left motor low frequency
		right motor high frequency
		xinput allows values of ??
		*/

	}

}
