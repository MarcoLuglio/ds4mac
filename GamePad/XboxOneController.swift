//
//  Xbox360Controller.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class XboxOneController {

	static let VENDOR_ID_MICROSOFT:Int64 = 0x045E // 1118

	static let CONTROLLER_ID_XBOX_ONE:Int64 = 0x02D1 // ?
	static let CONTROLLER_ID_XBOX_ONE_2015:Int64 = 0x02DD // ?
	static let CONTROLLER_ID_XBOX_ONE_BLUETOOTH:Int64 = 0x02E0 // ?

	static let CONTROLLER_ID_XBOX_ONE_ELITE:Int64 = 0x02E3 // ?

	static let CONTROLLER_ID_XBOX_ONE_S:Int64 = 0x02EA // ?
	static let CONTROLLER_ID_XBOX_ONE_S_BLUETOOTH:Int64 = 0x02FD // ?

	static let CONTROLLER_ID_XBOX_WIRELESS_DONGLE:Int64 = 0x02E6 // v2?

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	let productID:Int64
	let transport:String

	let device:IOHIDDevice

	var isBluetooth = false

	/// contains a, b, x, y and shoulder buttons
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

	// shoulder buttons ("bumper" buttons officially)
	var leftShoulderButton = false
	var previousLeftShoulderButton = false
	var rightShoulderButton = false
	var previousRightShoulderButton = false
	
	var leftTriggerButton = false // adding for compatibility, the report only has analog data
	var previousLeftTriggerButton = false
	var rightTriggerButton = false  // adding for compatibility, the report only has analog data
	var previousRightTriggerButton = false

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

	/// contains xbox, menu and thumbstick buttons
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

	// thumbstick buttons
	var leftStickButton = false
	var previousLeftStickButton = false
	var rightStickButton = false
	var previousRightStickButton = false

	// other buttons

	var viewButton = false
	var previousViewButton = false

	var menuButton = false
	var previousMenuButton = false

	var xboxButton = false
	var previousXboxButton = false

	// analog buttons

	var leftStickX:UInt16 = 0
	var previousLeftStickX:UInt16 = 0
	var leftStickY:UInt16 = 0
	var previousLeftStickY:UInt16 = 0
	var rightStickX:UInt16 = 0
	var previousRightStickX:UInt16 = 0
	var rightStickY:UInt16 = 0
	var previousRightStickY:UInt16 = 0
	
	var leftTrigger:UInt16 = 0
	var previousLeftTrigger:UInt16 = 0
	var rightTrigger:UInt16 = 0
	var previousRightTrigger:UInt16 = 0

	// battery ??

	/*
	var cableConnected = false
	var batteryCharging = false
	var batteryLevel:UInt8 = 0 // 0 to 10 on USB, 0 - 9 on Bluetooth
	var previousBatteryLevel:UInt8 = 0
	*/

	// misc

	//

	init(_ device:IOHIDDevice, productID:Int64, transport:String) {

		self.id = XboxOneController.nextId
		XboxOneController.nextId = XboxOneController.nextId + 1

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID
		self.device = device
		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		self.sendInitReport()

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: XboxOneChangeRumbleNotification.Name,
				object: nil
			)

		/*NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeLed),
				name: XboxOneChangeLedNotification.Name,
				object: nil
			)*/

		/*var ledPattern:XboxOneLedPattern

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

		sendLedReport(ledPattern:ledPattern)*/
		//sendRumbleReport(leftHeavySlowRumble: 30, rightLightFastRumble: 50)

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		// for xbox one
		// type ?, id ?, length 17 bytes

		// report[0] // always 0x01

		if report.count < 17 {
			return
		}

		self.directionalPad = report[13]

		self.mainButtons = report[14]

		self.yButton             = mainButtons & 0b0001_0000 == 0b0001_0000
		self.xButton             = mainButtons & 0b0000_1000 == 0b0000_1000
		self.bButton             = mainButtons & 0b0000_0010 == 0b0000_0010
		self.aButton             = mainButtons & 0b0000_0001 == 0b0000_0001

		self.rightShoulderButton = mainButtons & 0b1000_0000 == 0b1000_0000
		self.leftShoulderButton  = mainButtons & 0b0100_0000 == 0b0100_0000

		self.secondaryButtons = report[15]

		self.xboxButton       = secondaryButtons & 0b0001_0000 == 0b0001_0000
		self.menuButton       = secondaryButtons & 0b0000_1000 == 0b0000_1000

		self.leftStickButton  = secondaryButtons & 0b0010_0000 == 0b0010_0000
		self.rightStickButton = secondaryButtons & 0b0100_0000 == 0b0100_0000

		self.viewButton = report[16] & 0b0000_0001 == 0b0000_0001

		// triggers put here to enable digital reading of them
		self.leftTrigger  = UInt16(report[10] << 8) | UInt16(report[9])
		self.rightTrigger = UInt16(report[12] << 8) | UInt16(report[11])

		self.leftTriggerButton = self.leftTrigger > 0 // TODO improve this with a getter and or deadzone
		self.rightTriggerButton = self.rightTrigger > 0 // TODO improve this with a getter and or deadzone

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
						leftTriggerButton: self.leftTriggerButton,
						leftShoulderButton: self.leftShoulderButton,
						minusButton:false,
						leftSideTopButton:false,
						leftSideBottomButton:false,
						// TODO maybe save the dpad states individually?
						upButton: (self.directionalPad == XboxOneDirection.up.rawValue || self.directionalPad == XboxOneDirection.rightUp.rawValue || self.directionalPad == XboxOneDirection.leftUp.rawValue),
						rightButton: (self.directionalPad == XboxOneDirection.right.rawValue || self.directionalPad == XboxOneDirection.rightUp.rawValue || self.directionalPad == XboxOneDirection.rightDown.rawValue),
						downButton: (self.directionalPad == XboxOneDirection.down.rawValue || self.directionalPad == XboxOneDirection.rightDown.rawValue || self.directionalPad == XboxOneDirection.leftDown.rawValue),
						leftButton: (self.directionalPad == XboxOneDirection.left.rawValue || self.directionalPad == XboxOneDirection.leftUp.rawValue || self.directionalPad == XboxOneDirection.leftDown.rawValue),
						socialButton: self.viewButton,
						leftStickButton: self.leftStickButton,
						trackPadButton: false,
						centralButton: self.xboxButton,
						rightStickButton: self.rightStickButton,
						rightAuxiliaryButton: self.menuButton,
						faceNorthButton: self.yButton,
						faceEastButton: self.bButton,
						faceSouthButton: self.aButton,
						faceWestButton: self.xButton,
						rightSideBottomButton:false,
						rightSideTopButton:false,
						plusButton:false,
						rightShoulderButton: self.rightShoulderButton,
						rightTriggerButton: self.rightTriggerButton
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
			self.previousLeftTriggerButton = self.leftTriggerButton
			self.previousRightTriggerButton = self.rightTriggerButton
			self.previousLeftStickButton = self.leftStickButton
			self.previousRightStickButton = self.rightStickButton

			self.previousViewButton = self.viewButton
			self.previousMenuButton = self.menuButton
			self.previousXboxButton = self.xboxButton

		}

		// analog buttons
		// origin left top

		self.leftStickX  = UInt16(report[2]) << 8 | UInt16(report[1]) // 0 left
		self.leftStickY  = UInt16(report[4]) << 8 | UInt16(report[3]) // 0 up
		self.rightStickX = UInt16(report[6]) << 8 | UInt16(report[5])
		self.rightStickY = UInt16(report[8]) << 8 | UInt16(report[7])

		print("left stick x \(self.leftStickX)")
		print("left stick y \(self.leftStickY)")
		print("right stick x \(self.rightStickX)")
		print("right stick y \(self.rightStickY)")

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

		let o = notification.object as! XboxOneChangeRumbleNotification

		sendRumbleReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble,
			leftTriggerRumble: o.leftTriggerRumble,
			rightTriggerRumble: o.rightTriggerRumble
		)

	}

	/*
	@objc func changeLed(_ notification:Notification) {
		let o = notification.object as! XboxOneChangeLedNotification
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

		let xbox360ControllerOutputReport:[UInt8] = [0x01, 0x03, ledPattern.rawValue]
		let xbox360ControllerOutputReportLength = xbox360ControllerOutputReport.count

		/*
		let pointer = unsafeBitCast(xbox360ControllerOutputReport, to: UnsafePointer<Any>.self)

		IOHIDDeviceSetReportWithCallback(
			device,
			kIOHIDReportTypeInput,
			1,
			unsafeBitCast(xbox360ControllerOutputReport, to: UnsafePointer.self),
			xbox360ControllerOutputReportLength,
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
			xbox360ControllerOutputReport,
			xbox360ControllerOutputReportLength
		)

	}
	*/

	private func sendRumbleReport(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8, leftTriggerRumble:UInt8, rightTriggerRumble:UInt8) {

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

		let xboxOneControllerRumbleOutputReport:[UInt8] = [0x00, 0x08, 0x00, leftHeavySlowRumble, rightLightFastRumble, 0x00, 0x00, 0x00]
		let xboxOneControllerRumbleOutputReportLength = xboxOneControllerRumbleOutputReport.count

		/*
		let pointer = unsafeBitCast(xbox360ControllerOutputReport, to: UnsafePointer<Any>.self)

		IOHIDDeviceSetReportWithCallback(
			device,
			kIOHIDReportTypeInput,
			1,
			unsafeBitCast(xbox360ControllerOutputReport, to: UnsafePointer.self),
			xbox360ControllerOutputReportLength,
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
			xboxOneControllerRumbleOutputReport,
			xboxOneControllerRumbleOutputReportLength
		)

	}

	private func sendInitReport() {

		/*
		 * This packet is required for all Xbox One pads with 2015
		 * or later firmware installed (or present from the factory).
		 *
		static const u8 xboxone_fw2015_init[] = {
			0x05, 0x20, 0x00, 0x01, 0x00
		};

		*
		 * This packet is required for Xbox One S (0x045e:0x02ea)
		 * and Xbox One Elite Series 2 (0x045e:0x0b00) pads to
		 * initialize the controller that was previously used in
		 * Bluetooth mode.
		 *
		static const u8 xboxone_s_init[] = {
			0x05, 0x20, 0x00, 0x0f, 0x06
		};

		IOUSBInterface *com_lloeki_xbox_one_controller::findAndOpenInterface(IOUSBDevice *device) {
			IOUSBFindInterfaceRequest ifRequest;
			IOUSBInterface *interface;

			ifRequest.bInterfaceClass    = 0x00FF;
			ifRequest.bInterfaceSubClass = 0x0047;
			ifRequest.bInterfaceProtocol = 0x00D0;
			ifRequest.bAlternateSetting  = kIOUSBFindInterfaceDontCare;

			interface = device->FindNextInterface(NULL, &ifRequest);
			if (interface == NULL) { return NULL; }
			if (!interface->open(this)) { return NULL; }
			IOLog("[xbox_one_controller] interface #%d opened\n",
				  interface->GetInterfaceNumber());

			return interface;
		}

		IOUSBPipe *com_lloeki_xbox_one_controller::findAndOpenPipe(IOUSBInterface *interface, int direction) {
			IOUSBFindEndpointRequest pipeRequest;
			IOUSBPipe *pipe;

			pipeRequest.direction = direction;
			pipeRequest.type = kUSBInterrupt;
			pipeRequest.interval = 0;
			pipeRequest.maxPacketSize = 0;
			pipe = interface->FindNextPipe(NULL, &pipeRequest);
			if (pipe == NULL) { return NULL; }

			IOLog("[xbox_one_controller] pipe #%d opened: type=%d direction=%d, packet_size=%d\n",
				  pipe->GetEndpointNumber(),
				  pipe->GetType(),
				  pipe->GetDirection(),
				  pipe->GetMaxPacketSize());
			pipe->retain();

			return pipe;
		}
		*/

		let xboxOneControllerOutputReport:[UInt8] = [0x05, 0x20, 0x00, 0x0f, 0x06]
		//let xboxOneControllerOutputReport:[UInt8] = [0x05, 0x20, 0x00, 0x01, 0x00]
		let xboxOneControllerOutputReportLength = xboxOneControllerOutputReport.count

		let ioHidService = IOHIDDeviceGetService(self.device)

		// TODO send report like joy con

		//var parent = IORegistryEntryGetParentEntry(ioHidService, kIOUSBPlane, )

		/*var parent:io_object_t = 0
		var parents = ioHidService
		var dict:CFMutableDictionary;
		while (IORegistryEntryGetParentEntry(parents, kIOServicePlane, &parent) == KERN_SUCCESS)
		{
			var result = IORegistryEntryCreateCFProperties(parent, &dict, kCFAllocatorDefault, 0);
			if (!result)
				[array addObject:CFBridgingRelease(dict)];

			if (parents != port)
				IOObjectRelease(parents);
			parents = parent;
		}*/
		// TODO

		//var service = IOHIDDeviceGetService(self.device)
		//service.

	}

}
