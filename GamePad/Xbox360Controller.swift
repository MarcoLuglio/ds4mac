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
	static let CONTROLLER_ID_XBOX_360_WIRELESS:Int64 = 0x028F // ??
	static let CONTROLLER_ID_XBOX_WIRELESS_DONGLE:Int64 = 0x0291 // v1??
	static let CONTROLLER_ID_XBOX_WIRELESS_DONGLE_V2:Int64 = 0x02E6 // ??

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	let productID:Int64
	let transport:String

	let device:IOHIDDevice

	var isBluetooth = false

	/// contains a, b, x, y, shoulder and xbox buttons
	var mainButtons:UInt8 = 0
	var previousMainButtons:UInt8 = 0

	// top button
	var yButton = false
	var previousYButton = false

	// right button
	var bButton = false
	var previousBButton = false

	// bottom button
	var aButton = false
	var previousAButton = false

	// left button
	var xButton = false
	var previousXButton = false

	// shoulder buttons
	var leftShoulderButton = false
	var previousLeftShoulderButton = false
	var rightShoulderButton = false
	var previousRightShoulderButton = false
	var leftTriggerButton = false // adding for compatibility, the report only has analog data
	var previousLeftTriggerButton = false
	var rightTriggerButton = false  // adding for compatibility, the report only has analog data
	var previousRightTriggerButton = false

	/// contains start, back, thumbstick buttons and directionla pad
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	var topButton = false
	var previousTopButton = false
	var rightButton = false
	var previousRightButton = false
	var downButton = false
	var previousDownButton = false
	var leftButton = false
	var previousLeftButton = false

	// thumbstick buttons
	var leftStickButton = false
	var previousLeftStickButton = false
	var rightStickButton = false
	var previousRightStickButton = false

	// other buttons

	var backButton = false
	var previousBackButton = false
	var startButton = false
	var previousStartButton = false

	var xboxButton = false
	var previousXboxButton = false

	// analog buttons

	var leftStickX:Int16 = 0
	var previousLeftStickX:Int16 = 0
	var leftStickY:Int16 = 0
	var previousLeftStickY:Int16 = 0
	var rightStickX:Int16 = 0
	var previousRightStickX:Int16 = 0
	var rightStickY:Int16 = 0
	var previousRightStickY:Int16 = 0
	
	var leftTrigger:UInt8 = 0
	var previousLeftTrigger:UInt8 = 0
	var rightTrigger:UInt8 = 0
	var previousRightTrigger:UInt8 = 0

	// battery ??

	init(_ device:IOHIDDevice, productID:Int64, transport:String) {

		self.id = Xbox360Controller.nextId
		Xbox360Controller.nextId = Xbox360Controller.nextId + 1

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID
		self.device = device
		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: Xbox360ChangeRumbleNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeLed),
				name: Xbox360ChangeLedNotification.Name,
				object: nil
			)

		var ledPattern:Xbox360LedPattern

		switch self.id {
			case 0:
				ledPattern = Xbox360LedPattern.blink1
			case 1:
				ledPattern = Xbox360LedPattern.blink1
			case 2:
				ledPattern = Xbox360LedPattern.blink1
			case 3:
				ledPattern = Xbox360LedPattern.blink1
			default:
				ledPattern = Xbox360LedPattern.allBlink
		}

		sendLedReport(ledPattern:ledPattern)
		//sendRumbleReport(leftHeavySlowRumble: 30, rightLightFastRumble: 50)

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		// report[0] // always 0x00
		// report[1] // always 0x14

		// for xbox 360
		// type 0, id 0, length 20 bytes

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

		self.directionalPad   = secondaryButtons & 0b00001111

		// triggers put here to enable digital reading of them
		self.leftTrigger = report[4]
		self.rightTrigger = report[5]

		if self.previousMainButtons != self.mainButtons
			|| self.previousSecondaryButtons != self.secondaryButtons
			|| self.previousDirectionalPad != self.directionalPad
			|| self.previousLeftTrigger != self.leftTrigger
			|| self.previousRightTrigger != self.rightTrigger
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamepadButtonChangedNotification.Name,
					object: GamepadButtonChangedNotification(
						leftTriggerButton: self.leftTrigger > 0, // TODO improve this with a getter
						leftShoulderButton: self.leftShoulderButton,
						minusButton:false,
						leftSideTopButton:false,
						leftSideBottomButton:false,
						// TODO maybe save the dpad states individually?
						upButton:    self.secondaryButtons & 0b00000001 == 0b00000001,
						rightButton: self.secondaryButtons & 0b00001000 == 0b00001000,
						downButton:  self.secondaryButtons & 0b00000010 == 0b00000010,
						leftButton:  self.secondaryButtons & 0b00000100 == 0b00000100,
						socialButton: self.backButton,
						leftStickButton: self.leftStickButton,
						trackPadButton: false,
						centralButton: self.xboxButton,
						rightStickButton: self.rightStickButton,
						rightAuxiliaryButton: self.startButton,
						faceNorthButton: self.yButton,
						faceEastButton: self.bButton,
						faceSouthButton: self.aButton,
						faceWestButton: self.xButton,
						rightSideBottomButton:false,
						rightSideTopButton:false,
						plusButton:false,
						rightShoulderButton: self.rightShoulderButton,
						rightTriggerButton: self.rightTrigger > 0 // TODO improve this with a getter
					)
				)
			}

			self.previousMainButtons = self.mainButtons

			self.previousYButton = self.yButton
			self.previousBButton = self.bButton
			self.previousAButton = self.aButton
			self.previousXButton = self.xButton

			self.previousDirectionalPad = self.directionalPad

			self.previousSecondaryButtons = self.secondaryButtons

			self.previousLeftShoulderButton = self.leftShoulderButton
			self.previousRightShoulderButton = self.rightShoulderButton
			// TODO save and notify the triggers as digital readings for compatibility
			//self.previousLeftTriggerButton = self.leftTriggerButton
			//self.previousRightTriggerButton = self.rightTriggerButton
			self.previousLeftStickButton = self.leftStickButton
			self.previousRightStickButton = self.rightStickButton

			self.previousBackButton = self.backButton
			self.previousStartButton = self.startButton

			self.previousXboxButton = self.xboxButton

		}

		// analog buttons
		// origin left top

		self.leftStickX = Int16(report[7]) << 8 | Int16(report[6]) // 0 left
		self.leftStickY = Int16(report[9]) << 8 | Int16(report[8]) // 0 up
		self.rightStickX = Int16(report[11]) << 8 | Int16(report[10])
		self.rightStickY = Int16(report[13]) << 8 | Int16(report[12])

		if self.previousLeftStickX != self.leftStickX
			|| self.previousLeftStickY != self.leftStickY
			|| self.previousRightStickX != self.rightStickX
			|| self.previousRightStickY != self.rightStickY
			|| self.previousLeftTrigger != self.leftTrigger
			|| self.previousRightTrigger != self.rightTrigger
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamepadAnalogChangedNotification.Name,
					object: GamepadAnalogChangedNotification(
						leftStickX: self.leftStickX,
						leftStickY: self.leftStickY,
						rightStickX: self.rightStickX,
						rightStickY: self.rightStickY,
						leftTrigger: self.leftTrigger,
						rightTrigger: self.rightTrigger
					)
				)
			}

			self.previousLeftStickX = self.leftStickX
			self.previousLeftStickY = self.leftStickY
			self.previousRightStickX = self.rightStickX
			self.previousRightStickY = self.rightStickY
			self.previousLeftTrigger = self.leftTrigger
			self.previousRightTrigger = self.rightTrigger

		}

	}

	@objc func changeRumble(_ notification:Notification) {

		let o = notification.object as! Xbox360ChangeRumbleNotification

		sendRumbleReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble
		)

	}

	@objc func changeLed(_ notification:Notification) {
		let o = notification.object as! Xbox360ChangeLedNotification
		sendLedReport(ledPattern:o.ledPattern)
	}

	private func sendLedReport(ledPattern:Xbox360LedPattern) {

		/*
		message of the following form:

		0103xx
		0x01 is the message type
		0x03 is the message length
		0xXX is the desired pattern:

		Where xx is the byte led pattern
		*/

		let xbox360ControllerLedOutputReport:[UInt8] = [0x01, 0x03, ledPattern.rawValue]
		let xbox360ControllerLedOutputReportLength = xbox360ControllerLedOutputReport.count

		/*
		let pointer = unsafeBitCast(xbox360ControllerLedOutputReport, to: UnsafePointer<Any>.self)

		IOHIDDeviceSetReportWithCallback(
			device,
			kIOHIDReportTypeInput,
			1,
			unsafeBitCast(xbox360ControllerLedOutputReport, to: UnsafePointer.self),
			xbox360ControllerLedOutputReportLength,
			500, // timeout in what?? ms
			{() in
				//
			},
			hidContext
		)
		*/

		IOHIDDeviceSetReport(
			self.device,
			kIOHIDReportTypeOutput,
			0x01,
			xbox360ControllerLedOutputReport,
			xbox360ControllerLedOutputReportLength
		)

	}

	private func sendRumbleReport(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8) {

		// FIXME not working :(
		// maybe try a different driver...

		/*

		Updates to the controller’s user feedback features are sent on endpoint 1 OUT (0x01), also on interface 0.
		These updates follow the same format as the sent data, where byte 0 is the ‘type’ identifier and byte 1 is the packet length (in bytes).

		message of the following form:

		00 08 00 bb ll 00 00 00

		0x00 is the message type
		0x08 is the message length
		other 0x00 reserved for future use?

		Where b is the speed to set the motor with the big weight
		and l is the speed to set the small weight
		(0x00 to 0xFF in both cases).

		left motor low frequency
		right motor high frequency

		xinput allows values of ??
		*/

		let xbox360ControllerRumbleOutputReport:[UInt8] = [0x00, 0x08, 0x00, leftHeavySlowRumble, rightLightFastRumble, 0x00, 0x00, 0x00]
		let xbox360ControllerRumbleOutputReportLength = xbox360ControllerRumbleOutputReport.count

		/*
		let pointer = unsafeBitCast(xbox360ControllerRumbleOutputReport, to: UnsafePointer<Any>.self)

		IOHIDDeviceSetReportWithCallback(
			device,
			kIOHIDReportTypeInput,
			1,
			unsafeBitCast(xbox360ControllerRumbleOutputReport, to: UnsafePointer.self),
			xbox360ControllerRumbleOutputReportLength,
			500, // timeout in what?? ms
			{() in
				//
			},
			hidContext
		)
		*/

		IOHIDDeviceSetReport(
			self.device,
			kIOHIDReportTypeOutput,
			0x00, // report id, not sure which, 0x00, 0x01?
			xbox360ControllerRumbleOutputReport,
			xbox360ControllerRumbleOutputReportLength
		)

	}

}
