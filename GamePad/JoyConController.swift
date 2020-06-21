//
//  JoyConController.swift
//  GamePad
//
//  Created by Marco Luglio on 06/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class JoyConController {

	static let VENDOR_ID_NINTENDO:Int64 = 0x057E // 1406
	static let CONTROLLER_ID_JOY_CON_LEFT:Int64 = 0x2006 // 8198
	static let CONTROLLER_ID_JOY_CON_RIGHT:Int64 = 0x2007 // 8199
	static let CONTROLLER_ID_SWITCH_PRO:Int64 = 0x2009 // 8201
	static let CONTROLLER_ID_CHARGING_GRIP:Int64 = 0x200e // TODO
	// 0x0306 Wii Remote Controller RVL-003
	// 0x0337 Wii U GameCube Controller Adapter

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	var productID:Int64 = 0
	var transport:String = ""

	var isBluetooth = false

	// MARK: - left joy-con

	var leftDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var leftMainButtons:UInt8 = 0
	var previousLeftMainButtons:UInt8 = 0

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	var upButton = false
	var previousUpButton = false
	var rightButton = false
	var previousRightButton = false
	var downButton = false
	var previousDownButton = false
	var leftButton = false
	var previousLeftButton = false

	/// SL button on left joy-con
	var leftSideTopButton = false
	var previousLeftSideTopButton = false

	/// SR on left joy-con
	var leftSideBottomButton = false
	var previousLeftSideBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var leftSecondaryButtons:UInt8 = 0
	var previousLeftSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var leftShoulderButton = false
	var previousLeftShoulderButton = false
	var leftTriggerButton = false
	var previousLeftTriggerButton = false

	// other buttons

	var minusButton = false
	var previousMinusButton = false

	var captureButton = false
	var previousCaptureButton = false

	// thumbstick - it is not analog, only points the 8 directions
	// saving as Int8 for compatibility with other controllers
	var leftStickButton = false
	var previousLeftStickButton = false
	var leftStick:UInt8 = 0
	var previousLeftStick:UInt8 = 0
	var leftStickX:Int8 = 0
	var previousLeftStickX:Int8 = 0
	var leftStickY:Int8 = 0
	var previousLeftStickY:Int8 = 0

	// battery ??

	// MARK: - right joy-con

	var rightDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var rightMainButtons:UInt8 = 0
	var previousRightMainButtons:UInt8 = 0

	var faceButtons:UInt8 = 0
	var previousFaceButtons:UInt8 = 0

	var xButton = false
	var previousXButton = false
	var aButton = false
	var previousAButton = false
	var bButton = false
	var previousBButton = false
	var yButton = false
	var previousYButton = false

	/// SR button on right joy-con
	var rightSideTopButton = false
	var previousRightSideTopButton = false

	/// SL on right joy-con
	var rightSideBottomButton = false
	var previousRightSideBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var rightSecondaryButtons:UInt8 = 0
	var previousRightSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var rightShoulderButton = false
	var previousRightShoulderButton = false
	var rightTriggerButton = false
	var previousRightTriggerButton = false

	// other buttons

	var plusButton = false
	var previousPlusButton = false

	var homeButton = false
	var previousHomeButton = false

	// thumbstick - it is not analog, only points the 8 directions
	// saving as Int8 for compatibility with other controllers
	var rightStickButton = false
	var previousRightStickButton = false
	var rightStick:UInt8 = 0
	var previousRightStick:UInt8 = 0
	var rightStickX:Int8 = 0
	var previousRightStickX:Int8 = 0
	var rightStickY:Int8 = 0
	var previousRightStickY:Int8 = 0

	// battery ??

	// MARK: - Methods

	init(_ device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.id = JoyConController.nextId
		JoyConController.nextId = JoyConController.nextId + 1

		self.setDevice(device, productID:productID, transport:transport)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: JoyConChangeRumbleNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeLed),
				name: JoyConChangeLedNotification.Name,
				object: nil
			)

		/*

		Subcommand 0x30: Set player lights

		First argument byte is a bitfield:

		aaaa bbbb
			 3210 - keep player light on
		3210 - flash player light

		On overrides flashing. When on USB, flashing bits work like always on bits.
		Subcommand 0x31: Get player lights

		Replies with ACK xB0 x31 and one byte that uses the same bitfield with x30 subcommand

		xB1 is the 4 leds trail effect. But it can't be set via x30.

		*/

		/*
		uint8_t buf[0x40]; bzero(buf, 0x40);
		buf[0] = 1; // 0x10 for rumble only
		buf[1] = GlobalPacketNumber; // Increment by 1 for each packet sent. It loops in 0x0 - 0xF range.
		memcpy(buf + 2, rumbleData, 8);
		buf[10] = subcommandID;
		memcpy(buf + 11, subcommandData, subcommandDataLen);
		hid_write(handle, buf, 0x40);
		*/

		/*var joyConControllerLedOutputReport:[UInt8] = [0b00001000]
		let joyConControllerLedOutputReportLength = joyConControllerLedOutputReport.count

		IOHIDDeviceSetReport(
			self.leftDevice,
			kIOHIDReportTypeFeature, // input 0x01, output 0x02
			0x01,
			joyConControllerLedOutputReport,
			joyConControllerLedOutputReportLength
		)*/

		/*let joyConControllerInputReportModeOutputReport:[UInt8] = [0x30]
		let joyConControllerInputReportModeOutputReportLength = joyConControllerInputReportModeOutputReport.count

		IOHIDDeviceSetReport(
			self.leftDevice,
			kIOHIDReportTypeOutput,
			0x03,
			joyConControllerInputReportModeOutputReport,
			joyConControllerInputReportModeOutputReportLength
		)*/


		/*

		Subcommand 0x03: Set input report mode

		One argument:
		Arg # 	Remarks
		x00 	Used with cmd x11. Active polling for NFC/IR camera data. 0x31 data format must be set first.
		x01 	Same as 00. Active polling mode for NFC/IR MCU configuration data.
		x02 	Same as 00. Active polling mode for NFC/IR data and configuration. For specific NFC/IR modes
		x03 	Same as 00. Active polling mode for IR camera data. For specific IR modes
		x23 	MCU update state report?
		x30 	Standard full mode. Pushes current state @60Hz
		x31 	NFC/IR mode. Pushes large packets @60Hz
		x33 	Unknown mode.
		x35 	Unknown mode.
		x3F 	Simple HID mode. Pushes updates with every button press

		x31 input report has all zeroes for IR/NFC data if a 11 ouput report with subcmd 03 00/01/02/03 was not sent before.







		Subcommand 0x22: Set NFC/IR MCU state

		Takes one argument:
		Argument # 	Remarks
		00 	Suspend
		01 	Resume
		02 	Resume for update










		Subcommand 0x48: Enable vibration

		One argument of x00 Disable or x01 Enable.


		OUTPUT 0x01

		Rumble and subcommand.

		The OUTPUT 1 report is how all normal subcommands are sent. It also includes rumble data.

		Sample C code for sending a subcommand:

		uint8_t buf[0x40]; bzero(buf, 0x40);
		buf[0] = 1; // 0x10 for rumble only
		buf[1] = GlobalPacketNumber; // Increment by 1 for each packet sent. It loops in 0x0 - 0xF range.
		memcpy(buf + 2, rumbleData, 8);
		buf[10] = subcommandID;
		memcpy(buf + 11, subcommandData, subcommandDataLen);
		hid_write(handle, buf, 0x40);

		You can send rumble data and subcommand with x01 command, otherwise only rumble with x10 command.

		See "Rumble data" below.
		OUTPUT 0x03

		NFC/IR MCU FW Update packet.
		OUTPUT 0x10

		Rumble only. See OUTPUT 0x01 and "Rumble data" below.
		OUTPUT 0x11

		Request specific data from the NFC/IR MCU. Can also send rumble.




		Rumble data

		A timing byte, then 4 bytes of rumble data for left Joy-Con, followed by 4 bytes for right Joy-Con. [00 01 40 40 00 01 40 40] (320Hz 0.0f 160Hz 0.0f) is neutral. The rumble data structure contains 2 bytes High Band data, 2 byte Low Band data. The values for HF Band frequency and LF amplitude are encoded.
		Byte # 	Range 	Remarks
		0, 4 	x04 - xFC (81.75Hz - 313.14Hz) 	High Band Lower Frequency. Steps +0x0004.
		0-1, 4-5 	x00 01 - xFC 01 (320.00Hz - 1252.57Hz) 	Byte 1,5 LSB enables High Band Higher Frequency. Steps +0x0400.
		1, 5 	x00 00 - xC8 00 (0.0f - 1.0f) 	High Band Amplitude. Steps +0x0200. Real max: FE.
		2, 6 	x01 - x7F (40.87Hz - 626.28Hz) 	Low Band Frequency.
		3, 7 	x40 - x72 (0.0f - 1.0f) 	Low Band Amplitude. Safe max: 00 72.
		2-3, 6-7 	x80 40 - x80 71 (0.01f - 0.98f) 	Byte 2,6 +0x80 enables intermediate LF amplitude. Real max: 80 FF.

		For a rumble values table, example and the algorithm for frequency, check rumble_data_table.md.

		The byte values for frequency raise the frequency in Hz exponentially and not linearly.

		Don't use real maximum values for Amplitude. Otherwise, they can damage the linear actuators. These safe amplitude ranges are defined by Switch HID library.




		*/

	}

	func setDevice(_ device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID
		if productID == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {
			self.rightDevice = device
			IOHIDDeviceOpen(self.rightDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
		} else {
			self.leftDevice = device
			IOHIDDeviceOpen(self.leftDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
		}

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data, controllerType:Int64) {

		// report[0] // is the report type
		// 0x3F is just buttons, 0x21 is just buttons (dufferent than 3F??), 0x30 includes gyro, 0x31 includes NFC (large packet size)

		if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_LEFT {

			self.leftMainButtons = report[1]

			self.directionalPad = leftMainButtons & 0b00001111

			self.upButton   = self.directionalPad & 0b00000100 == 0b00000100
			self.rightButton = self.directionalPad & 0b00001000 == 0b00001000
			self.downButton  = self.directionalPad & 0b00000010 == 0b00000010
			self.leftButton  = self.directionalPad & 0b00000001 == 0b00000001

			self.leftSideTopButton    = leftMainButtons & 0b00010000 == 0b00010000
			self.leftSideBottomButton = leftMainButtons & 0b00100000 == 0b00100000

			self.leftSecondaryButtons = report[2]

			self.leftShoulderButton = leftSecondaryButtons & 0b01000000 == 0b01000000
			self.leftTriggerButton  = leftSecondaryButtons & 0b10000000 == 0b10000000

			self.minusButton        = leftSecondaryButtons & 0b00000001 == 0b00000001
			self.captureButton      = leftSecondaryButtons & 0b00100000 == 0b00100000

			self.leftStickButton    = leftSecondaryButtons & 0b00000100 == 0b00000100

			if leftMainButtons != self.previousLeftMainButtons
				|| leftSecondaryButtons != self.previousLeftSecondaryButtons
			{

				DispatchQueue.main.async {
					NotificationCenter.default.post(
						name: GamePadButtonChangedNotification.Name,
						object: GamePadButtonChangedNotification(
							leftTriggerButton: self.leftTriggerButton,
							leftShoulderButton: self.leftShoulderButton,
							upButton: self.upButton,
							rightButton: self.rightButton,
							downButton: self.downButton,
							leftButton: self.leftButton,
							socialButton: self.captureButton,
							leftStickButton: self.leftStickButton,
							trackPadButton: false,
							centralButton: false,
							rightStickButton: self.rightStickButton,
							rightAuxiliaryButton: self.homeButton,
							faceNorthButton: self.xButton,
							faceEastButton: self.yButton,
							faceSouthButton: self.bButton,
							faceWestButton: self.aButton,
							rightShoulderButton: self.rightShoulderButton,
							rightTriggerButton: self.rightTriggerButton
						)
					)
				}

				self.previousLeftMainButtons = self.leftMainButtons

				self.previousDirectionalPad = self.directionalPad

				self.previousUpButton = self.upButton
				self.previousRightButton = self.rightButton
				self.previousDownButton = self.downButton
				self.previousLeftButton = self.leftButton

				self.previousLeftSideTopButton = self.leftSideTopButton
				self.previousLeftSideBottomButton = self.leftSideBottomButton

				self.previousLeftSecondaryButtons = self.leftSecondaryButtons

				self.previousLeftShoulderButton = self.leftShoulderButton
				self.previousLeftTriggerButton = self.leftTriggerButton

				self.previousMinusButton = self.minusButton
				self.previousCaptureButton = self.captureButton

				self.previousLeftStickButton = self.leftStickButton

			}

			self.leftStick = report[3]

			// origin left top for compatibility with other controllers

			if self.leftStick == JoyConLeftDirection.right.rawValue || self.leftStick == JoyConLeftDirection.rightUp.rawValue || self.leftStick == JoyConLeftDirection.rightDown.rawValue {
				self.leftStickX = 1
			} else if self.leftStick == JoyConLeftDirection.left.rawValue || self.leftStick == JoyConLeftDirection.leftUp.rawValue || self.leftStick == JoyConLeftDirection.leftDown.rawValue {
				self.leftStickX = -1
			} else {
				self.leftStickX = 0
			}

			if self.leftStick == 2 || self.leftStick == 3 || self.leftStick == 1 {
				self.leftStickY = 1
			} else if self.leftStick == JoyConLeftDirection.up.rawValue || self.leftStick == JoyConLeftDirection.leftUp.rawValue || self.leftStick == JoyConLeftDirection.rightUp.rawValue {
				self.leftStickY = -1
			} else {
				self.leftStickY = 0
			}

			// TODO send "analog" notification

		} else if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {

			self.rightMainButtons = report[1]

			self.faceButtons = rightMainButtons & 0b00001111

			print(String(self.faceButtons, radix:2))

			self.xButton = self.faceButtons & 0b00000010 == 0b00000010
			self.aButton = self.faceButtons & 0b00000001 == 0b00000001
			self.bButton = self.faceButtons & 0b00000100 == 0b00000100
			self.yButton = self.faceButtons & 0b00001000 == 0b00001000

			self.rightSideTopButton    = rightMainButtons & 0b00100000 == 0b00100000
			self.rightSideBottomButton = rightMainButtons & 0b00010000 == 0b00010000

			self.rightSecondaryButtons = report[2]

			self.rightShoulderButton = rightSecondaryButtons & 0b01000000 == 0b01000000
			self.rightTriggerButton  = rightSecondaryButtons & 0b10000000 == 0b10000000

			print(String(rightSecondaryButtons, radix: 2))

			self.plusButton          = rightSecondaryButtons & 0b00000010 == 0b00000010
			self.homeButton          = rightSecondaryButtons & 0b00010000 == 0b00010000

			self.rightStickButton    = rightSecondaryButtons & 0b00001000 == 0b00001000

			if rightMainButtons != self.previousRightMainButtons
				|| rightSecondaryButtons != self.previousRightSecondaryButtons
			{

				DispatchQueue.main.async {
					NotificationCenter.default.post(
						name: GamePadButtonChangedNotification.Name,
						object: GamePadButtonChangedNotification(
							leftTriggerButton: self.leftTriggerButton,
							leftShoulderButton: self.leftShoulderButton,
							upButton: self.upButton,
							rightButton: self.rightButton,
							downButton: self.downButton,
							leftButton: self.leftButton,
							socialButton: self.captureButton,
							leftStickButton: self.leftStickButton,
							trackPadButton: false,
							centralButton: false,
							rightStickButton: self.rightStickButton,
							rightAuxiliaryButton: self.homeButton,
							faceNorthButton: self.xButton,
							faceEastButton: self.aButton,
							faceSouthButton: self.bButton,
							faceWestButton: self.yButton,
							rightShoulderButton: self.rightShoulderButton,
							rightTriggerButton: self.rightTriggerButton
						)
					)
				}

				self.previousRightMainButtons = self.rightMainButtons

				self.previousFaceButtons = self.faceButtons

				self.previousXButton = self.xButton
				self.previousAButton = self.aButton
				self.previousBButton = self.bButton
				self.previousYButton = self.yButton

				self.previousRightSideTopButton = self.rightSideTopButton
				self.previousRightSideBottomButton = self.rightSideBottomButton

				self.previousRightSecondaryButtons = self.rightSecondaryButtons

				self.previousRightShoulderButton = self.rightShoulderButton
				self.previousRightTriggerButton = self.rightTriggerButton

				self.previousPlusButton = self.plusButton
				self.previousHomeButton = self.homeButton

				self.previousRightStickButton = self.rightStickButton

			}

			self.rightStick = report[3]

			// origin left top for compatibility with other controllers

			if self.rightStick == JoyConRightDirection.right.rawValue || self.rightStick == JoyConRightDirection.rightUp.rawValue || self.rightStick == JoyConRightDirection.rightDown.rawValue {
				self.rightStickX = 1
			} else if self.rightStick == JoyConRightDirection.left.rawValue || self.rightStick == JoyConRightDirection.leftUp.rawValue || self.rightStick == JoyConRightDirection.leftDown.rawValue {
				self.rightStickX = -1
			} else {
				self.rightStickX = 0
			}

			if self.rightStick == 2 || self.rightStick == 3 || self.rightStick == 1 {
				self.rightStickY = 1
			} else if self.rightStick == JoyConRightDirection.up.rawValue || self.rightStick == JoyConRightDirection.leftUp.rawValue || self.rightStick == JoyConRightDirection.rightUp.rawValue {
				self.rightStickY = -1
			} else {
				self.rightStickY = 0
			}

		}

		// 4-7 (Pro Con) 	x40 8A 4F 8A 	Left analog stick data
		// 8-11 (Pro Con) 	xD0 7E DF 7F 	Right analog stick data
		// for joy-cons this can be ignored

	}

	@objc func changeRumble(_ notification:Notification) {

		let o = notification.object as! JoyConChangeRumbleNotification

		/*sendRumbleReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble,
			leftTriggerRumble: o.leftTriggerRumble,
			rightTriggerRumble: o.rightTriggerRumble
		)*/

	}

	@objc func changeLed(_ notification:Notification) {

		let o = notification.object as! JoyConChangeLedNotification

		/*

		static const u8 JC_SUBCMD_SET_PLAYER_LIGHTS	= 0x30;
		static const u8 JC_SUBCMD_GET_PLAYER_LIGHTS	= 0x31;
		static const u8 JC_SUBCMD_SET_HOME_LIGHT	= 0x38;

		struct joycon_subcmd_request *req;
		u8 buffer[sizeof(*req) + 1] = { 0 };

		req = (struct joycon_subcmd_request *)buffer;
		req->subcmd_id = JC_SUBCMD_SET_PLAYER_LIGHTS;
		req->data[0] = (flash << 4) | on;

		hid_dbg(ctlr->hdev, "setting player leds\n");
		return joycon_send_subcmd(ctlr, req, 1, HZ/4);
		*/

		//sendLedReport(ledPattern:o.ledPattern)*/
	}

}
