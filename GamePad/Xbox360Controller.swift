//
//  Xbox360Controller.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class Xbox360Controller {

	static let VENDOR_ID_MICROSOFT:Int64 = 1118
	static let CONTROLLER_ID_XBOX_360:Int64 = 654

	let device:IOHIDDevice

	init(_ device:IOHIDDevice) {
		self.device = device
		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
		self.sendReport()
	}

	func parseReport(_ report:Data) {

		// let

		/*
		Reports are type 0x00, and seem to be 20 bytes long:

		0014ttttxxyyaaaaaaaabbbbbbbb000000000000

		Where x is the left trigger, y is the right trigger, a is the left hat, b is the right hat and t is the buttons:
		0x0001 	Left shoulder
		0x0002 	Right shoulder
		0x0004 	XBox button
		0x0008
		0x0010 	A
		0x0020 	B
		0x0040 	X
		0x0080 	Y
		0x0100 	D-pad up
		0x0200 	D-pad down
		0x0400 	D-pad left
		0x0800 	D-pad right
		0x1000 	Start
		0x2000 	Back
		0x4000 	Left hat button
		0x8000 	Right hat button

		At startup, the device seems to report 01030E. I believe this to indicate that there are 14 options (e.g. 0 to D hex) for the LEDs.
		*/

	}

	private func sendReport() {

		/*message type 0x01.
		of the following form:

		0x14 is 20 bytes

		0103xx
		0x01 is the message type, 0x03 is the message length, and 0xXX is the desired pattern:

		Where xx is the desired pattern:
		0x00 	All off
		0x01 	All blinking
		0x02 	1 flashes, then on
		0x03 	2 flashes, then on
		0x04 	3 flashes, then on
		0x05 	4 flashes, then on
		0x06 	1 on
		0x07 	2 on
		0x08 	3 on
		0x09 	4 on
		0x0A 	Rotating (e.g. 1-2-4-3)
		0x0B 	Blinking*
		0x0C 	Slow blinking*
		0x0D 	Alternating (e.g. 1+4-2+3), then back to previous*/

		let xbox360ControllerInputReport:[UInt8] = [0x01, 0x03, 0x06]
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
			xbox360ControllerInputReportLength // 0x03
		)

		/*
		Rumbling is also similar to on the original controller. Rumble commands take the following form:
		000800bbll000000
		Where b is the speed to set the motor with the big weight, and l is the speed to set the small weight (0x00 to 0xFF in both cases).
		right motor high frequency
		left motor low frequency
		xinput allows values of
		*/

		//

	}

}
