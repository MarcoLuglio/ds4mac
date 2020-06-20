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
	static let CONTROLLER_ID_CHARGING_GRIP:Int64 = 0x0000 // TODO
	static let CONTROLLER_ID_SWITCH_PRO:Int64 = 0x2009 // 8201
	// 0x0306 Wii Remote Controller RVL-003
	// 0x0337 Wii U GameCube Controller Adapter

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	let productID:Int64
	let transport:String

	let leftDevice:IOHIDDevice
	//let rightDevice:IOHIDDevice!

	var isBluetooth = false

	// left joy-con

	/// contains dpad and left side buttons
	var mainButtons:UInt8 = 0
	var previousMainButtons:UInt8 = 0

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

	/// SL button on left joy-con
	var leftSideTopButton = false
	var previousLeftSideTopButton = false

	/// SR on left joy-con
	var leftSideBottomButton = false
	var previousLeftSideBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

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






	/////////////

	var rightShoulderButton = false
	var previousRightShoulderButton = false
	var rightTriggerButton = false
	var previousRightTriggerButton = false

	// thumbstick buttons
	var rightStickButton = false
	var previousRightStickButton = false

	// top button
	var xButton = false
	var previousXButton = false

	// right button
	var aButton = false
	var previousAButton = false

	// bottom button
	var bButton = false
	var previousBButton = false

	// left button
	var yButton = false
	var previousYButton = false





	// other buttons

	/*var windowsButton:Bool = false
	var previousWindowsButton:Bool = false
	var menuButton:Bool = false
	var previousMenuButton:Bool = false

	var xboxButton:Bool = false
	var previousXboxButton:Bool = false*/


	var rightStickX:Int16 = 0
	var previousRightStickX:Int16 = 0
	var rightStickY:Int16 = 0
	var previousRightStickY:Int16 = 0

	// adding for compatibility, the controller troggers are not analog
	/*var leftTrigger:UInt8 = 0
	var previousLeftTrigger:UInt8 = 0
	var rightTrigger:UInt8 = 0
	var previousRightTrigger:UInt8 = 0*/

	// battery ??

	init(_ device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.id = JoyConController.nextId
		JoyConController.nextId = JoyConController.nextId + 1

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID
		self.leftDevice = device
		IOHIDDeviceOpen(self.leftDevice, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

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

		// TODO set led here

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		// report[0] // always 63 - TODO in 0x??

		self.mainButtons = report[1]

		self.directionalPad   = mainButtons & 0b00001111

		self.topButton   = self.directionalPad & 0b00000100 == 0b00000100
		self.rightButton = self.directionalPad & 0b00001000 == 0b00001000
		self.downButton  = self.directionalPad & 0b00000010 == 0b00000010
		self.leftButton  = self.directionalPad & 0b00000001 == 0b00000001

		self.leftSideTopButton = mainButtons & 0b00010000 == 0b00010000
		self.leftSideBottomButton = mainButtons & 0b00100000 == 0b00100000

		self.secondaryButtons = report[2]

		self.leftShoulderButton = secondaryButtons & 0b01000000 == 0b01000000
		self.leftTriggerButton  = secondaryButtons & 0b10000000 == 0b10000000

		self.minusButton        = secondaryButtons & 0b00000001 == 0b00000001
		self.captureButton      = secondaryButtons & 0b00100000 == 0b00100000

		self.leftStickButton    = secondaryButtons & 0b00000100 == 0b00000100

		self.leftStick = report[3]

		// origin left top for compatibility with other controllers

		if self.leftStick == JoyConDirection.right.rawValue || self.leftStick == JoyConDirection.rightUp.rawValue || self.leftStick == JoyConDirection.rightDown.rawValue {
			self.leftStickX = 1
		} else if self.leftStick == JoyConDirection.left.rawValue || self.leftStick == JoyConDirection.leftUp.rawValue || self.leftStick == JoyConDirection.leftDown.rawValue {
			self.leftStickX = -1
		} else {
			self.leftStickX = 0
		}

		if self.leftStick == 2 || self.leftStick == 3 || self.leftStick == 1 {
			self.leftStickY = 1
		} else if self.leftStick == JoyConDirection.up.rawValue || self.leftStick == JoyConDirection.leftUp.rawValue || self.leftStick == JoyConDirection.rightUp.rawValue {
			self.leftStickY = -1
		} else {
			self.leftStickY = 0
		}

		print("count: \(report.count)")
		print(" 1: \(String(report[1], radix: 2))")
		print(" 2: \(String(report[2], radix: 2))")
		print(" 3: \(String(report[3], radix: 2))")

		// for reports without IMU
		/*print(" 4: \(String(report[4], radix: 2))")
		print(" 5: \(report[5])") // always 128
		print(" 6: \(report[6])") // always 0
		print(" 7: \(report[7])") // always 128
		print(" 8: \(report[8])") // always 0
		print(" 9: \(report[9])") // always 128
		print(" 10: \(report[10])") // always 0
		print(" 11: \(report[11])") // always 128*/

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
