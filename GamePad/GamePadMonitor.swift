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

	var xbox360Controller:Xbox360Controller!
	var dualShock4Controller:DualShock4Controller!

	init() {
		//
	}

	// MARK: - HID Manager

	@objc func setupHidObservers() {

		let hidManager = IOHIDManagerCreate(kCFAllocatorDefault, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		// reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void
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
			hidContext // reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
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
			hidContext // reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
		)

		// register a callback for gamepad sending input reports
		IOHIDManagerRegisterInputReportCallback(
			hidManager,
			{(context, result, sender, reportType, reportID, reportPointer, reportLength) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				// Put report bytes in a Swift friendly object
				let report = Data(bytes:reportPointer, count:reportLength)

				// must call another function to avoid creating a closure, which is not supported for c functions
				return caller.inputReportCallback(result:result, sender:sender!, reportType:reportType, reportID:reportID, report:report)

			},
			hidContext  // reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
		)

		RunLoop.current.run()

	}

	// MARK: HID Manager callbacks

	func hidDeviceAddedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void
		let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		let productName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString);
		let productID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as! Int64;
		let vendorName = IOHIDDeviceGetProperty(device, kIOHIDManufacturerKey as CFString);
		let vendorID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as! Int64;
		let transport = IOHIDDeviceGetProperty(device, kIOHIDTransportKey as CFString);

		// not sure if I'll need this
		// let reportInterval = IOHIDDeviceGetProperty(device, kIOHIDReportIntervalKey as CFString);
		// print(reportInterval!) // for DS4 11250 micro seconds or 11.25ms

		print(productName!)
		print(vendorName!)
		print(transport!)

		if vendorID == Xbox360Controller.VENDOR_ID_MICROSOFT && productID == Xbox360Controller.CONTROLLER_ID_XBOX_360 {
			self.xbox360Controller = Xbox360Controller(device)
		} else if vendorID == DualShock4Controller.VENDOR_ID_SONY
			&& (productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_USB || productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_USB_V2 || productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_BLUETOOTH)
		{
			self.dualShock4Controller = DualShock4Controller(device, productID: productID, transport: transport as! String, enableIMUReport: true)
		}

	}

	func hidDeviceRemovedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// reference to self (GamePadMonitor) that can be passed to c functions, essentially a pointer to void
		// let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		// TODO not sure what to do here

	}

	/// gamepad input report callback
	func inputReportCallback(result:IOReturn, sender:UnsafeMutableRawPointer, reportType:IOHIDReportType, reportID:UInt32, report:Data) {

		// report type will always be 0 (input), because this callback was only registered for this type of reports

		let device = unsafeBitCast(sender, to: IOHIDDevice.self)

		// figure out which device send this report
		if device == self.xbox360Controller?.device {
			self.xbox360Controller.parseReport(report) // TODO maybe pass the report id
		} else if device == self.dualShock4Controller?.device {
			self.dualShock4Controller.parseReport(report) // TODO maybe pass the report id
		} else {
			print("report id: \(String(reportID, radix: 16))")
			print ("report size: \(report.count)")
		}

	}

}
