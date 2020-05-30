//
//  GamePadMonitor.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Cocoa
import Foundation

import GameController

import IOKit
import IOKit.usb
import IOKit.usb.IOUSBLib
import IOKit.hid

//import ForceFeedback


class GamePadMonitor {

	/*
	dualshock 4
	ID do Produto:	0x05c4
	ID do Revendedor:	0x054c  (Sony Corporation)
	Versão:	1.00
	Velocidade:	Até 12 Mb/s
	Fabricante:	Sony Computer Entertainment
	ID da Localização:	0x14300000 / 2
	Corrente Elétrica Disponível (mA):	500
	Corrente Elétrica Requerida (mA):	500
	Corrente de Funcionamento Extra (mA):	0

	xbox360 wired
	ID do Produto:	0x028e
	ID do Revendedor:	0x045e  (Microsoft Corporation)
	Versão:	1.14
	Número de Série:	1512ACD
	Velocidade:	Até 12 Mb/s
	Fabricante:	©Microsoft Corporation
	ID da Localização:	0x14600000 / 3
	Corrente Elétrica Disponível (mA):	500
	Corrente Elétrica Requerida (mA):	500
	Corrente de Funcionamento Extra (mA):	0
	*/

	init() {
		//
	}

	// MARK: - HID Manager

	@objc func setupHidObservers() {

		let hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		// reference to self that can be passed to c functions, essentially a pointer to void
		let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		// CFArray and NSArray are compatible
		// Creating an CFArray requires pointers, so I'm using an NSArray
		// C function that uses this requires CFArray
		let deviceCriteria:NSArray = [
			/*[
				kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
				kIOHIDDeviceUsageKey: kHIDUsage_GD_Mouse
			]*/
			[
				kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
				kIOHIDDeviceUsageKey: kHIDUsage_GD_Joystick
			],
			[
				kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
				kIOHIDDeviceUsageKey: kHIDUsage_GD_GamePad
			],
			[
				kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
				kIOHIDDeviceUsageKey: kHIDUsage_GD_MultiAxisController
			],
			[
				kIOHIDDeviceUsagePageKey: kHIDPage_PID, // force feedback
				kIOHIDDeviceUsageKey: kHIDUsage_PID_PhysicalInterfaceDevice
			]
			// kHIDUsage_Undefined // all usage pages
		]

		//let deviceCriteria

		// filter hid devices based on criteria above
		IOHIDManagerSetDeviceMatchingMultiple(hidManager, deviceCriteria)

		// starts hid manager monitoring of devices
		IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) // also have to call IOHIDManagerUnscheduleFromRunLoop at some point
		IOHIDManagerOpen(hidManager, IOOptionBits(kIOHIDOptionsTypeNone)) // also have to call IOHIDManagerClose at some point

		// registers a callback for gamepad being connected
		IOHIDManagerRegisterDeviceMatchingCallback(
			hidManager,
			{(context, result, sender, device) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				// must call another function to avoid creating a closure, which is not supported for c functions
				return caller.hidDeviceAddedCallback(result, sender:sender!, device:device)

			},
			hidContext // reference to self that can be passed to c functions, essentially a pointer to void
		)

		// registers a callback for gamepad being disconnected
		IOHIDManagerRegisterDeviceRemovalCallback(
			hidManager,
			{(context, result, sender, device) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				// must call another function to avoid creating a closure, which is not supported for c functions
				return caller.hidDeviceRemovedCallback(result, sender:sender!, device:device)

			},
			hidContext // reference to self that can be passed to c functions, essentially a pointer to void
		)

		IOHIDManagerRegisterInputReportCallback(
			hidManager,
			{(context, result, sender, reportType, reportID, report, reportLength) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				// for ds4 - this is correct!
				print(NSDate())
				print(reportType) // 0
				print(reportID) // 1
				print(reportLength) // 64

				// for xbox 360
				// type 0, id 0, length 0x14 or 20 bytes

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

			},
			hidContext
		)

		RunLoop.current.run()

	}

	// MARK: HID Manager callbacks

	func hidDeviceAddedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// TODO match the hardware device with a swift object

		// reference to self that can be passed to c functions, essentially a pointer to void
		let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		IOHIDDeviceOpen(device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		/*IOHIDDeviceRegisterInputValueCallback(
			device,
			{(context, result, sender, deviceValue) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				caller.hidDeviceInputCallback(result, sender:sender!, deviceValue: deviceValue)

			},
			hidContext
		)*/

		/*IOHIDDeviceRegisterInputReportCallback(
			device,
			report, // Pointer to preallocated buffer in which to copy inbound report data.
			0, //reportLenght, // lenght of preallocated buffer
			{() in
				//
			},
			hidContext
		)*/

		/*IOHIDDeviceSetValueWithCallback(
			//
		)

		IOHIDDeviceSetValueMultipleWithCallback(
			//
		)
		*/

		let productName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString);
		let productID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as! Int64;
		let vendorName = IOHIDDeviceGetProperty(device, kIOHIDManufacturerKey as CFString);
		let vendorID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as! Int64;

		print(productName!) // Xbox 360 Wired Controller
		print(vendorName!) // ©Microsoft Corporation

		let VENDOR_ID_MICROSOFT:Int64 = 1118
		let CONTROLLER_ID_XBOX_360:Int64 = 654
		let VENDOR_ID_SONY:Int64 = 1356
		let CONTROLLER_ID_DUALSHOCK_4:Int64 = 1476 // not sure if this is a generic id or not, name is Wireless Controller

		if vendorID == VENDOR_ID_MICROSOFT && productID == CONTROLLER_ID_XBOX_360 {

			let xbox360Controller = Xbox360Controller(device)

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
			let xbox360ControllerInputReportLength = MemoryLayout.size(ofValue:xbox360ControllerInputReport)
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
				device,
				kIOHIDReportTypeOutput,
				0x01,
				xbox360ControllerInputReport,
				0x03 // xbox360ControllerInputReportLength,
			)

			/*
			Rumbling is also similar to on the original controller. Rumble commands take the following form:
			000800bbll000000
			Where b is the speed to set the motor with the big weight, and l is the speed to set the small weight (0x00 to 0xFF in both cases).
			*/

			//

		} else if vendorID == VENDOR_ID_SONY && productID == CONTROLLER_ID_DUALSHOCK_4 {

			let dualshock4Controller = Dualshock4Controller(device)

			// TODO send report here too?

			/*
			HID OUTPUT

			These reports are sent asynchronously from the PS4 to the DS4.
			0x11

			The transaction type is DATA (0x0a), and the report type is OUTPUT (0x02). The protocol code is 0x11.

			Byte at index 4 changes from 0xf0 to 0xf3 in the first reports. Making it always 0xf0 does not seem to change something.

			Report example:

			0xa2, 0x11, 0xc0, 0x20, 0xf0, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x43, 0x00, 0x4d, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd8, 0x8e, 0x94, 0xdd

			Data Format byte index 	bit 7 	bit 6 	bit 5 	bit 4 	bit 3 	bit 2 	bit 1 	bit 0
			[0] 	0x0a 	0x00 	0x02
			[1] 	0x11
			[2 - 3] 	Unknown
			[4] 	0xf0 disables the rumble motors, 0xf3 enables them
			[5 - 6] 	Unknown
			[7] 	Rumble (right / weak)
			[8] 	Rumble (left / strong)
			[9] 	RGB color (Red)
			[10] 	RGB color (Green)
			[11] 	RGB color (Blue)
			[12 - 74] 	Unknown
			[75 - 78] 	CRC-32 of the previous bytes.


			Report with id 11

			Number of bytes: 78.
			It contains rumbles, LED color and volume headset speakers/built-in speaker/mic.
			11 c0 20 f0 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 43 43 00 4f 85 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 64 e4 c6 3b

			Report with id 14
			Number of bytes: 270.
			It contains sound.
			14 40 a0 3c 02 02 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ba 0e 08 5d

			Report with id 17
			Number of bytes: 462.
			It contains sound.
			17 40 a0 24 7a 02 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 00 00 00 00 30 71 71 87

			Report with id 15
			Number of bytes: 334.
			It contains rumbles, LED color, volume headset speakers/built-in speaker/mic, and sound.
			15 c0 a0 f3 44 00 00 00 b0 50 00 00 00 00 00 00 00 00 00 00 00 43 43 00 4f 85 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0 b0 02 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 9c 75 19 24 00 00 00 00 00 00 00 00 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 76 db 6d bb 6d b6 dd b6 db 6e db 6d b7 6d b6 db b6 db 6d db 6d b6 ed b6 db 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 19 f8 d2 1c

			Report with id 19
			Number of bytes: 567.
			It contains rumbles, LED color, volume headset speakers/built-in speaker/mic, and sound.
			19 c0 a0 f3 44 00 00 00 00 00 0d 00 00 00 00 00 00 00 00 00 00 43 43 00 4f 85 00 00 00 00 00 00 00 00

			*/

			let dualshock4ControllerInputReport:[UInt8] = [
				0xa2, 0x11, 0xc0, 0x20, 0xf0, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x43, 0x43, 0x00, 0x4d, 0x85, 0x00, 0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
				0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xd8, 0x8e, 0x94, 0xdd
			]
			let dualshock4ControllerInputReportLength = MemoryLayout.size(ofValue:dualshock4ControllerInputReport)
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
				device,
				kIOHIDReportTypeOutput,
				0x01,
				dualshock4ControllerInputReport,
				0x03 // dualshock4ControllerInputReportLength,
			)

		}

		//self.index = 0;

		/*let cfElements = IOHIDDeviceCopyMatchingElements(device, nil, IOOptionBits(kIOHIDOptionsTypeNone)); // nil gets all elements?
		let nsElements:NSArray = cfElements! as NSArray
		let elements:Array<IOHIDElement> = nsElements as! Array<IOHIDElement>

		for element in elements {

			let type = IOHIDElementGetType(element)
			let usage = IOHIDElementGetUsage(element)
			let usagePage = IOHIDElementGetUsagePage(element)
			let pMax = IOHIDElementGetPhysicalMax(element)
			let pMin = IOHIDElementGetPhysicalMin(element)
			let lMax = IOHIDElementGetLogicalMax(element)
			let lMin = IOHIDElementGetLogicalMin(element)
			//let elementProperty = IOHIDElementGetProperty(element, "key" as CFString)

			//		if(usagePage != 1 || usagePage == 9) {
			//			NSLog(@"Skipping usage page %x usage %x", usagePage, usage);
			//			continue;
			//		}


			print("\n\ntype: \(type)")
			print("usage: \(getUsage(usage))")
			print("usagePage: \(usagePage)")
			print("physical max: \(pMax)")
			print("physical min: \(pMin)")
			print("logical max: \(lMax)")
			print("logical min: \(lMin)")

			switch (Int(usagePage)) {

				case kHIDPage_Undefined:
					print("kHIDPage_Undefined")
				case kHIDPage_GenericDesktop:
					print("kHIDPage_GenericDesktop")
				case kHIDPage_Simulation:
					print("kHIDPage_Simulation")
				case kHIDPage_VR:
					print("kHIDPage_VR")
				case kHIDPage_Sport:
					print("kHIDPage_Sport")
				case kHIDPage_Game:
					print("kHIDPage_Game")
				case kHIDPage_GenericDeviceControls:
					print("kHIDPage_GenericDeviceControls")
				case kHIDPage_KeyboardOrKeypad:
					print("kHIDPage_KeyboardOrKeypad")
				case kHIDPage_LEDs:
					print("kHIDPage_LEDs")
				case kHIDPage_Button:
					print("kHIDPage_Button")
				case kHIDPage_Ordinal:
					print("kHIDPage_Ordinal")
				case kHIDPage_Telephony:
					print("kHIDPage_Telephony")
				case kHIDPage_Consumer:
					print("kHIDPage_Consumer")
				case kHIDPage_Digitizer:
					print("kHIDPage_Digitizer")
				/* Reserved 0x0E */
				case kHIDPage_PID:
					print("kHIDPage_PID")
				case kHIDPage_Unicode:
					print("kHIDPage_Unicode")
				/* Reserved 0x11 - 0x13 */
				case kHIDPage_AlphanumericDisplay:
					print("kHIDPage_AlphanumericDisplay")
				/* Reserved 0x15 - 0x1F */
				case kHIDPage_Sensor:
					print("kHIDPage_Sensor")
				/* Reserved 0x21 - 0x7f */
				case kHIDPage_Monitor:
					print("kHIDPage_Monitor")
				case kHIDPage_MonitorEnumerated:
					print("kHIDPage_MonitorEnumerated")
				case kHIDPage_MonitorVirtual:
					print("kHIDPage_MonitorVirtual")
				case kHIDPage_MonitorReserved:
					print("kHIDPage_MonitorReserved")
				/* Power 0x84 - 0x87     USB Device Class Definition for Power Devices */
				case kHIDPage_PowerDevice:
					print("kHIDPage_PowerDevice")
				case kHIDPage_BatterySystem:
					print("kHIDPage_BatterySystem")
				case kHIDPage_PowerReserved:
					print("kHIDPage_PowerReserved")
				case kHIDPage_PowerReserved2:
					print("kHIDPage_PowerReserved2")
				/* Reserved 0x88 - 0x8B */
				case kHIDPage_BarCodeScanner:
					print("kHIDPage_BarCodeScanner")
				case kHIDPage_WeighingDevice:
					print("kHIDPage_WeighingDevice")
				case kHIDPage_Scale:
					print("kHIDPage_Scale")
				case kHIDPage_MagneticStripeReader:
					print("kHIDPage_MagneticStripeReader")
				/* ReservedPointofSalepages 0x8F */
				case kHIDPage_CameraControl:
					print("kHIDPage_CameraControl")
				case kHIDPage_Arcade:
					print("kHIDPage_Arcade")
				/* Reserved 0x92 - 0xFEFF */
				/* VendorDefined 0xFF00 - 0xFFFF */
				case kHIDPage_VendorDefinedStart:
					print("kHIDPage_VendorDefinedStart")
				default:
					print("something else")

			}

			switch type {
				case kIOHIDElementTypeInput_Misc:
					print("misc")
				case kIOHIDElementTypeInput_Button:
					print("button")
				case kIOHIDElementTypeInput_Axis:
					print("axis")
				case kIOHIDElementTypeInput_ScanCodes:
					print("scan codes")
				case kIOHIDElementTypeOutput:
					print("output")
				case kIOHIDElementTypeFeature:
					print("feature")
				case kIOHIDElementTypeCollection:
					print("collection")
				case kIOHIDElementTypeInput_NULL:
					print("null")
				default:
					print("unknown type!?")
			}

			if (pMax - pMin == 1) || usagePage == UInt32(kHIDPage_Button) || type == kIOHIDElementTypeInput_Button {
				//let action:Action
				/*
				action = [[JSActionButton alloc] initWithIndex: buttons++ andName: (NSString *)elName];
				[(JSActionButton*)action setMax: max];
				*/
			}

		}*/

		/*

		int buttons = 0;
		int axes = 0;

		for(int i=0; i<[elements count]; i++) {

			//		if(usagePage != 1 || usagePage == 9) {
			//			NSLog(@"Skipping usage page %x usage %x", usagePage, usage);
			//			continue;
			//		}

			JSAction* action = NULL;

			if((max - min == 1) || usagePage == kHIDPage_Button || type == kIOHIDElementTypeInput_Button) {
				action = [[JSActionButton alloc] initWithIndex: buttons++ andName: (NSString *)elName];
				[(JSActionButton*)action setMax: max];
			} else if(usage == 0x39) {
				action = [[JSActionHat alloc] init];
			} else {
				if(usage >= 0x30 && usage < 0x36) {
					action = [[JSActionAnalog alloc] initWithIndex: axes++];
					[(JSActionAnalog*)action setMax: (double)max];
					[(JSActionAnalog*)action setMin: (double)min];
				} else {
					continue;
				}
			}

			[action setBase: self];
			[action setUsage: usage];
			[action setCookie: IOHIDElementGetCookie(element)];
			[children addObject:action];
		}
		*/







	}

	func hidDeviceRemovedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// reference to self that can be passed to c functions, essentially a pointer to void
		// let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		// TODO not sure what to do here

	}

	func hidDeviceInputCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, deviceValue:IOHIDValue) {

		// restoring the swift type of the pointer to void
		let device = unsafeBitCast(sender, to: IOHIDDevice.self)

		// logic to match the hardware device with the swift object
		// let joystick = self.findJoystickByReference(device)

		//print(deviceValue) // até aqui ok \o/

		let productID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as! Int64;
		let vendorID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as! Int64;
		// TODO serial number se tivesse mais que um controle do mesmo tipo

		let element = IOHIDValueGetElement(deviceValue)
		let usage = IOHIDElementGetUsage(element)

		let integerValue = IOHIDValueGetIntegerValue(deviceValue)
		let length = IOHIDValueGetLength(deviceValue)
		//let scaledValue = IOHIDValueGetScaledValue(deviceValue)

		// para xbox 360
		/*switch Int(usage) {

			// thubstick left x
			case kHIDUsage_GD_X:
				print("thumbstick left x")
				break;

			// thubstick left y
			case kHIDUsage_GD_Y:
				print("thumbstick left y")
				break;

			// thubstick right x
			case kHIDUsage_GD_Rx:
				print("thumbstick right x")
				break;

			// thubstick right y
			case kHIDUsage_GD_Ry:
				print("thumbstick right y")
				break;

			default:
				break

		}*/

		// para dualshock 4
		switch Int(usage) {

			case kHIDUsage_GD_X:
				print("kHIDUsage_GD_X")
				break;

			case kHIDUsage_GD_Y:
				print("kHIDUsage_GD_Y")
				break;

			case kHIDUsage_GD_Z:
				print("kHIDUsage_GD_Z")
				break;

			case kHIDUsage_GD_Rx:
				print("kHIDUsage_GD_Rx")
				break;

			case kHIDUsage_GD_Ry:
				print("kHIDUsage_GD_Ry") // ?
				break;

			case kHIDUsage_GD_Rz:
				print("kHIDUsage_GD_Rz") // ?
				break;

			case kHIDUsage_GD_Vx:
				print("kHIDUsage_GD_Vx")
				break;

			case kHIDUsage_GD_Vy:
				print("kHIDUsage_GD_Vy")
				break;

			case kHIDUsage_GD_Vz:
				print("kHIDUsage_GD_Vz")
				break;

			case kHIDUsage_GD_Vbrx:
				print("kHIDUsage_GD_Vbrx")
				break;

			case kHIDUsage_GD_Vbry:
				print("kHIDUsage_GD_Vbry")
				break;

			case kHIDUsage_GD_Vbry:
				print("kHIDUsage_GD_Vbrz")
				break;

			case kHIDUsage_GD_Vno:
				print("kHIDUsage_GD_Vno")
				break;

			default:
				//return
				break

		}

		print("integerValue: \(integerValue)")
		print("length: \(length)")


		/*IOHIDValueGetBytePtr

		Returns a byte pointer to the value contained in this IOHIDValueRef.
		IOHIDValueGetElement

		Returns the element value associated with this IOHIDValueRef.
		IOHIDValueGetIntegerValue

		Returns an integer representaion of the value contained in this IOHIDValueRef.
		IOHIDValueGetLength

		Returns the size, in bytes, of the value contained in this IOHIDValueRef.
		IOHIDValueGetScaledValue

		Returns an scaled representaion of the value contained in this IOHIDValueRef based on the scale type.
		IOHIDValueGetTimeStamp

		Returns the timestamp value contained in this IOHIDValueRef.
		IOHIDValueGetTypeID

		Returns the type identifier of all IOHIDValue instances.*/

	}

	// MARK: - Gamepad

	// MARK: - Utils

	func getUsage(_ usageType:UInt32) -> String {

		switch Int(usageType) {

			case kHIDUsage_Undefined:
				return "kHIDUsage_Undefined"

			/* GenericDesktop Page (0x01) */

			case kHIDUsage_GD_Pointer:
				return "kHIDUsage_GD_Pointer"
			case kHIDUsage_GD_Mouse:
				return "kHIDUsage_GD_Mouse"
			/* 0x03 Reserved */
			case kHIDUsage_GD_Joystick:
				return "kHIDUsage_GD_Joystick"
			case kHIDUsage_GD_GamePad:
				return "kHIDUsage_GD_GamePad"
			case kHIDUsage_GD_Keyboard:
				return "kHIDUsage_GD_Keyboard"
			case kHIDUsage_GD_Keypad:
				return "kHIDUsage_GD_Keypad"
			case kHIDUsage_GD_MultiAxisController:
				return "kHIDUsage_GD_MultiAxisController"
			case kHIDUsage_GD_TabletPCSystemControls:
				return "kHIDUsage_GD_TabletPCSystemControls"
			case kHIDUsage_GD_AssistiveControl:
				return "kHIDUsage_GD_AssistiveControl"
			case kHIDUsage_GD_SpatialController:
				return "kHIDUsage_GD_SpatialController"
			case kHIDUsage_GD_AssistiveControlCompatible:
				return "kHIDUsage_GD_AssistiveControlCompatible"
			/* 0x0B - 0x2F Reserved */
			case kHIDUsage_GD_X:
				return "kHIDUsage_GD_X"
			case kHIDUsage_GD_Y:
				return "kHIDUsage_GD_Y"
			case kHIDUsage_GD_Z:
				return "kHIDUsage_GD_Z"
			case kHIDUsage_GD_Rx:
				return "kHIDUsage_GD_Rx"
			case kHIDUsage_GD_Ry:
				return "kHIDUsage_GD_Ry"
			case kHIDUsage_GD_Rz:
				return "kHIDUsage_GD_Rz"
			case kHIDUsage_GD_Slider:
				return "kHIDUsage_GD_Slider"
			case kHIDUsage_GD_Dial:
				return "kHIDUsage_GD_Dial"
			case kHIDUsage_GD_Wheel:
				return "kHIDUsage_GD_Wheel"
			case kHIDUsage_GD_Hatswitch:
				return "kHIDUsage_GD_Hatswitch"
			case kHIDUsage_GD_CountedBuffer:
				return "kHIDUsage_GD_CountedBuffer"
			case kHIDUsage_GD_ByteCount:
				return "kHIDUsage_GD_ByteCount"
			case kHIDUsage_GD_MotionWakeup:
				return "kHIDUsage_GD_MotionWakeup"
			case kHIDUsage_GD_Start:
				return "kHIDUsage_GD_Start"
			case kHIDUsage_GD_Select:
				return "kHIDUsage_GD_Select"
			/* 0x3F Reserved */
			case kHIDUsage_GD_Vx:
				return "kHIDUsage_GD_Vx"
			case kHIDUsage_GD_Vy:
				return "kHIDUsage_GD_Vy"
			case kHIDUsage_GD_Vz:
				return "kHIDUsage_GD_Vz"
			case kHIDUsage_GD_Vbrx:
				return "kHIDUsage_GD_Vbrx"
			case kHIDUsage_GD_Vbry:
				return "kHIDUsage_GD_Vbry"
			case kHIDUsage_GD_Vbrz:
				return "kHIDUsage_GD_Vbrz"
			case kHIDUsage_GD_Vno:
				return "kHIDUsage_GD_Vno"
			/* 0x47 - 0x7F Reserved */
			case kHIDUsage_GD_SystemControl:
				return "kHIDUsage_GD_SystemControl"
			case kHIDUsage_GD_SystemPowerDown:
				return "kHIDUsage_GD_SystemPowerDown"
			case kHIDUsage_GD_SystemSleep:
				return "kHIDUsage_GD_SystemSleep"
			case kHIDUsage_GD_SystemWakeUp:
				return "kHIDUsage_GD_SystemWakeUp"
			case kHIDUsage_GD_SystemContextMenu:
				return "kHIDUsage_GD_SystemContextMenu"
			case kHIDUsage_GD_SystemMainMenu:
				return "kHIDUsage_GD_SystemMainMenu"
			case kHIDUsage_GD_SystemAppMenu:
				return "kHIDUsage_GD_SystemAppMenu"
			case kHIDUsage_GD_SystemMenuHelp:
				return "kHIDUsage_GD_SystemMenuHelp"
			case kHIDUsage_GD_SystemMenuExit:
				return "kHIDUsage_GD_SystemMenuExit"
			case kHIDUsage_GD_SystemMenuSelect:
				return "kHIDUsage_GD_SystemMenuSelect"
			case kHIDUsage_GD_SystemMenu:
				return "kHIDUsage_GD_SystemMenu"
			case kHIDUsage_GD_SystemMenuRight:
				return "kHIDUsage_GD_SystemMenuRight"
			case kHIDUsage_GD_SystemMenuLeft:
				return "kHIDUsage_GD_SystemMenuLeft"
			case kHIDUsage_GD_SystemMenuUp:
				return "kHIDUsage_GD_SystemMenuUp"
			case kHIDUsage_GD_SystemMenuDown:
				return "kHIDUsage_GD_SystemMenuDown"
			/* 0x8E - 0x8F Reserved */
			case kHIDUsage_GD_DPadUp:
				return "kHIDUsage_GD_DPadUp"
			case kHIDUsage_GD_DPadDown:
				return "kHIDUsage_GD_DPadDown"
			case kHIDUsage_GD_DPadRight:
				return "kHIDUsage_GD_DPadRight"
			case kHIDUsage_GD_DPadLeft:
				return "kHIDUsage_GD_DPadLeft"
			case kHIDUsage_GD_IndexTrigger:
				return "kHIDUsage_GD_IndexTrigger"
			case kHIDUsage_GD_PalmTrigger:
				return "kHIDUsage_GD_PalmTrigger"
			case kHIDUsage_GD_Thumbstick:
				return "kHIDUsage_GD_Thumbstick"
			/* 0x94 - 0xFFFF Reserved */
			case kHIDUsage_GD_Reserved:
				return "kHIDUsage_GD_Reserved"

			/* Simulation Page (0x02) */
			/* This section provides detailed descriptions of the usages employed by simulation devices. */

			case kHIDUsage_Sim_FlightSimulationDevice:
				return "kHIDUsage_Sim_FlightSimulationDevice"
			case kHIDUsage_Sim_AutomobileSimulationDevice:
				return "kHIDUsage_Sim_AutomobileSimulationDevice"
			case kHIDUsage_Sim_TankSimulationDevice:
				return "kHIDUsage_Sim_TankSimulationDevice"
			case kHIDUsage_Sim_SpaceshipSimulationDevice:
				return "kHIDUsage_Sim_SpaceshipSimulationDevice"
			case kHIDUsage_Sim_SubmarineSimulationDevice:
				return "kHIDUsage_Sim_SubmarineSimulationDevice"
			case kHIDUsage_Sim_SailingSimulationDevice:
				return "kHIDUsage_Sim_SailingSimulationDevice"
			case kHIDUsage_Sim_MotorcycleSimulationDevice:
				return "kHIDUsage_Sim_MotorcycleSimulationDevice"
			case kHIDUsage_Sim_SportsSimulationDevice:
				return "kHIDUsage_Sim_SportsSimulationDevice"
			case kHIDUsage_Sim_AirplaneSimulationDevice:
				return "kHIDUsage_Sim_AirplaneSimulationDevice"
			case kHIDUsage_Sim_HelicopterSimulationDevice:
				return "kHIDUsage_Sim_HelicopterSimulationDevice"
			case kHIDUsage_Sim_MagicCarpetSimulationDevice:
				return "kHIDUsage_Sim_MagicCarpetSimulationDevice"
			case kHIDUsage_Sim_BicycleSimulationDevice:
				return "kHIDUsage_Sim_BicycleSimulationDevice"
			/* 0x0D - 0x1F Reserved */
			case kHIDUsage_Sim_FlightControlStick:
				return "kHIDUsage_Sim_FlightControlStick"
			case kHIDUsage_Sim_FlightStick:
				return "kHIDUsage_Sim_FlightStick"
			case kHIDUsage_Sim_CyclicControl:
				return "kHIDUsage_Sim_CyclicControl"
			case kHIDUsage_Sim_CyclicTrim:
				return "kHIDUsage_Sim_CyclicTrim"
			case kHIDUsage_Sim_FlightYoke:
				return "kHIDUsage_Sim_FlightYoke"
			case kHIDUsage_Sim_TrackControl:
				return "kHIDUsage_Sim_TrackControl"
			/* 0x26 - 0xAF Reserved */
			case kHIDUsage_Sim_Aileron:
				return "kHIDUsage_Sim_Aileron"
			case kHIDUsage_Sim_AileronTrim:
				return "kHIDUsage_Sim_AileronTrim"
			case kHIDUsage_Sim_AntiTorqueControl:
				return "kHIDUsage_Sim_AntiTorqueControl"
			case kHIDUsage_Sim_AutopilotEnable:
				return "kHIDUsage_Sim_AutopilotEnable"
			case kHIDUsage_Sim_ChaffRelease:
				return "kHIDUsage_Sim_ChaffRelease"
			case kHIDUsage_Sim_CollectiveControl:
				return "kHIDUsage_Sim_CollectiveControl"
			case kHIDUsage_Sim_DiveBrake:
				return "kHIDUsage_Sim_DiveBrake"
			case kHIDUsage_Sim_ElectronicCountermeasures:
				return "kHIDUsage_Sim_ElectronicCountermeasures"
			case kHIDUsage_Sim_Elevator:
				return "kHIDUsage_Sim_Elevator"
			case kHIDUsage_Sim_ElevatorTrim:
				return "kHIDUsage_Sim_ElevatorTrim"
			case kHIDUsage_Sim_Rudder:
				return "kHIDUsage_Sim_Rudder"
			case kHIDUsage_Sim_Throttle:
				return "kHIDUsage_Sim_Throttle"
			case kHIDUsage_Sim_FlightCommunications:
				return "kHIDUsage_Sim_FlightCommunications"
			case kHIDUsage_Sim_FlareRelease:
				return "kHIDUsage_Sim_FlareRelease"
			case kHIDUsage_Sim_LandingGear:
				return "kHIDUsage_Sim_LandingGear"
			case kHIDUsage_Sim_ToeBrake:
				return "kHIDUsage_Sim_ToeBrake"
			case kHIDUsage_Sim_Trigger:
				return "kHIDUsage_Sim_Trigger"
			case kHIDUsage_Sim_WeaponsArm:
				return "kHIDUsage_Sim_WeaponsArm"
			case kHIDUsage_Sim_Weapons:
				return "kHIDUsage_Sim_Weapons"
			case kHIDUsage_Sim_WingFlaps:
				return "kHIDUsage_Sim_WingFlaps"
			case kHIDUsage_Sim_Accelerator:
				return "kHIDUsage_Sim_Accelerator"
			case kHIDUsage_Sim_Brake:
				return "kHIDUsage_Sim_Brake"
			case kHIDUsage_Sim_Clutch:
				return "kHIDUsage_Sim_Clutch"
			case kHIDUsage_Sim_Shifter:
				return "kHIDUsage_Sim_Shifter"
			case kHIDUsage_Sim_Steering:
				return "kHIDUsage_Sim_Steering"
			case kHIDUsage_Sim_TurretDirection:
				return "kHIDUsage_Sim_TurretDirection"
			case kHIDUsage_Sim_BarrelElevation:
				return "kHIDUsage_Sim_BarrelElevation"
			case kHIDUsage_Sim_DivePlane:
				return "kHIDUsage_Sim_DivePlane"
			case kHIDUsage_Sim_Ballast:
				return "kHIDUsage_Sim_Ballast"
			case kHIDUsage_Sim_BicycleCrank:
				return "kHIDUsage_Sim_BicycleCrank"
			case kHIDUsage_Sim_HandleBars:
				return "kHIDUsage_Sim_HandleBars"
			case kHIDUsage_Sim_FrontBrake:
				return "kHIDUsage_Sim_FrontBrake"
			case kHIDUsage_Sim_RearBrake:
				return "kHIDUsage_Sim_RearBrake"
			/* 0xD1 - 0xFFFF Reserved */
			case kHIDUsage_Sim_Reserved:
				return "kHIDUsage_Sim_Reserved"

			/* VR Page (0x03) */
			/* Virtual Reality controls depend on designators to identify the individual controls. Most of the following are */
			/* usages are applied to the collections of entities that comprise the actual device. */

			case kHIDUsage_VR_Belt:
				return "kHIDUsage_VR_Belt"
			case kHIDUsage_VR_BodySuit:
				return "kHIDUsage_VR_BodySuit"
			case kHIDUsage_VR_Flexor:
				return "kHIDUsage_VR_Flexor"
			case kHIDUsage_VR_Glove:
				return "kHIDUsage_VR_Glove"
			case kHIDUsage_VR_HeadTracker:
				return "kHIDUsage_VR_HeadTracker"
			case kHIDUsage_VR_HeadMountedDisplay:
				return "kHIDUsage_VR_HeadMountedDisplay"
			case kHIDUsage_VR_HandTracker:
				return "kHIDUsage_VR_HandTracker"
			case kHIDUsage_VR_Oculometer:
				return "kHIDUsage_VR_Oculometer"
			case kHIDUsage_VR_Vest:
				return "kHIDUsage_VR_Vest"
			case kHIDUsage_VR_AnimatronicDevice:
				return "kHIDUsage_VR_AnimatronicDevice"
			/* 0x0B - 0x1F Reserved */
			case kHIDUsage_VR_StereoEnable:
				return "kHIDUsage_VR_StereoEnable"
			case kHIDUsage_VR_DisplayEnable:
				return "kHIDUsage_VR_DisplayEnable"
			/* 0x22 - 0xFFFF Reserved */
			case kHIDUsage_VR_Reserved:
				return "kHIDUsage_VR_Reserved"

			/* Sport Page (0x04) */

			case kHIDUsage_Sprt_BaseballBat:
				return "kHIDUsage_Sprt_BaseballBat"
			case kHIDUsage_Sprt_GolfClub:
				return "kHIDUsage_Sprt_GolfClub"
			case kHIDUsage_Sprt_RowingMachine:
				return "kHIDUsage_Sprt_RowingMachine"
			case kHIDUsage_Sprt_Treadmill:
				return "kHIDUsage_Sprt_Treadmill"
			/* 0x05 - 0x2F Reserved */
			case kHIDUsage_Sprt_Oar:
				return "kHIDUsage_Sprt_Oar"
			case kHIDUsage_Sprt_Slope:
				return "kHIDUsage_Sprt_Slope"
			case kHIDUsage_Sprt_Rate:
				return "kHIDUsage_Sprt_Rate"
			case kHIDUsage_Sprt_StickSpeed:
				return "kHIDUsage_Sprt_StickSpeed"
			case kHIDUsage_Sprt_StickFaceAngle:
				return "kHIDUsage_Sprt_StickFaceAngle"
			case kHIDUsage_Sprt_StickHeelOrToe:
				return "kHIDUsage_Sprt_StickHeelOrToe"
			case kHIDUsage_Sprt_StickFollowThrough:
				return "kHIDUsage_Sprt_StickFollowThrough"
			case kHIDUsage_Sprt_StickTempo:
				return "kHIDUsage_Sprt_StickTempo"
			case kHIDUsage_Sprt_StickType:
				return "kHIDUsage_Sprt_StickType"
			case kHIDUsage_Sprt_StickHeight:
				return "kHIDUsage_Sprt_StickHeight"
			/* 0x3A - 0x4F Reserved */
			case kHIDUsage_Sprt_Putter:
				return "kHIDUsage_Sprt_Putter"
			case kHIDUsage_Sprt_1Iron:
				return "kHIDUsage_Sprt_1Iron"
			case kHIDUsage_Sprt_2Iron:
				return "kHIDUsage_Sprt_2Iron"
			case kHIDUsage_Sprt_3Iron:
				return "kHIDUsage_Sprt_3Iron"
			case kHIDUsage_Sprt_4Iron:
				return "kHIDUsage_Sprt_4Iron"
			case kHIDUsage_Sprt_5Iron:
				return "kHIDUsage_Sprt_5Iron"
			case kHIDUsage_Sprt_6Iron:
				return "kHIDUsage_Sprt_6Iron"
			case kHIDUsage_Sprt_7Iron:
				return "kHIDUsage_Sprt_7Iron"
			case kHIDUsage_Sprt_8Iron:
				return "kHIDUsage_Sprt_8Iron"
			case kHIDUsage_Sprt_9Iron:
				return "kHIDUsage_Sprt_9Iron"
			case kHIDUsage_Sprt_10Iron:
				return "kHIDUsage_Sprt_10Iron"
			case kHIDUsage_Sprt_11Iron:
				return "kHIDUsage_Sprt_11Iron"
			case kHIDUsage_Sprt_SandWedge:
				return "kHIDUsage_Sprt_SandWedge"
			case kHIDUsage_Sprt_LoftWedge:
				return "kHIDUsage_Sprt_LoftWedge"
			case kHIDUsage_Sprt_PowerWedge:
				return "kHIDUsage_Sprt_PowerWedge"
			case kHIDUsage_Sprt_1Wood:
				return "kHIDUsage_Sprt_1Wood"
			case kHIDUsage_Sprt_3Wood:
				return "kHIDUsage_Sprt_3Wood"
			case kHIDUsage_Sprt_5Wood:
				return "kHIDUsage_Sprt_5Wood"
			case kHIDUsage_Sprt_7Wood:
				return "kHIDUsage_Sprt_7Wood"
			case kHIDUsage_Sprt_9Wood:
				return "kHIDUsage_Sprt_9Wood"
			/* 0x64 - 0xFFFF Reserved */
			case kHIDUsage_Sprt_Reserved:
				return "kHIDUsage_Sprt_Reserved"

			/* Game Page (0x05) */

			case kHIDUsage_Game_3DGameController:
				return "kHIDUsage_Game_3DGameController"
			case kHIDUsage_Game_PinballDevice:
				return "kHIDUsage_Game_PinballDevice"
			case kHIDUsage_Game_GunDevice:
				return "kHIDUsage_Game_GunDevice"
			/* 0x04 - 0x1F Reserved */
			case kHIDUsage_Game_PointofView:
				return "kHIDUsage_Game_PointofView"
			case kHIDUsage_Game_TurnRightOrLeft:
				return "kHIDUsage_Game_TurnRightOrLeft"
			case kHIDUsage_Game_PitchUpOrDown:
				return "kHIDUsage_Game_PitchUpOrDown"
			case kHIDUsage_Game_RollRightOrLeft:
				return "kHIDUsage_Game_RollRightOrLeft"
			case kHIDUsage_Game_MoveRightOrLeft:
				return "kHIDUsage_Game_MoveRightOrLeft"
			case kHIDUsage_Game_MoveForwardOrBackward:
				return "kHIDUsage_Game_MoveForwardOrBackward"
			case kHIDUsage_Game_MoveUpOrDown:
				return "kHIDUsage_Game_MoveUpOrDown"
			case kHIDUsage_Game_LeanRightOrLeft:
				return "kHIDUsage_Game_LeanRightOrLeft"
			case kHIDUsage_Game_LeanForwardOrBackward:
				return "kHIDUsage_Game_LeanForwardOrBackward"
			case kHIDUsage_Game_HeightOfPOV:
				return "kHIDUsage_Game_HeightOfPOV"
			case kHIDUsage_Game_Flipper:
				return "kHIDUsage_Game_Flipper"
			case kHIDUsage_Game_SecondaryFlipper:
				return "kHIDUsage_Game_SecondaryFlipper"
			case kHIDUsage_Game_Bump:
				return "kHIDUsage_Game_Bump"
			case kHIDUsage_Game_NewGame:
				return "kHIDUsage_Game_NewGame"
			case kHIDUsage_Game_ShootBall:
				return "kHIDUsage_Game_ShootBall"
			case kHIDUsage_Game_Player:
				return "kHIDUsage_Game_Player"
			case kHIDUsage_Game_GunBolt:
				return "kHIDUsage_Game_GunBolt"
			case kHIDUsage_Game_GunClip:
				return "kHIDUsage_Game_GunClip"
			case kHIDUsage_Game_Gun:
				return "kHIDUsage_Game_Gun"
			case kHIDUsage_Game_GunSingleShot:
				return "kHIDUsage_Game_GunSingleShot"
			case kHIDUsage_Game_GunBurst:
				return "kHIDUsage_Game_GunBurst"
			case kHIDUsage_Game_GunAutomatic:
				return "kHIDUsage_Game_GunAutomatic"
			case kHIDUsage_Game_GunSafety:
				return "kHIDUsage_Game_GunSafety"
			case kHIDUsage_Game_GamepadFireOrJump:
				return "kHIDUsage_Game_GamepadFireOrJump"
			case kHIDUsage_Game_GamepadTrigger:
				return "kHIDUsage_Game_GamepadTrigger"
			case kHIDUsage_Game_GamepadFormFitting_Compatibility:
				return "kHIDUsage_Game_GamepadFormFitting_Compatibility"
			case kHIDUsage_Game_GamepadFormFitting:
				return "kHIDUsage_Game_GamepadFormFitting"
			/* 0x3A - 0xFFFF Reserved */
			case kHIDUsage_Game_Reserved:
				return "kHIDUsage_Game_Reserved"

			/* Generic Device Controls (0x0g) */

			case kHIDUsage_GenDevControls_BackgroundControls:
				return "kHIDUsage_GenDevControls_BackgroundControls"

			default:
				return "unknown"

		}

	}

}
