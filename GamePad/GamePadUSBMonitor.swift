//
//  GamePadUSBMonitor.swift
//  GamePad
//
//  Created by Marco Luglio on 21/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamePadUSBMonitor {

	func a() {

		/*
		check for reference https://github.com/zneak/xb1controller/blob/master/XboxOneControllerDriver/XboxOneController.cpp
		IOService *provider
		IOUSBInterface* interface = nullptr;
		IOUSBPipe* interruptPipe = nullptr;
		IOReturn ior = kIOReturnSuccess;
		IOUSBFindEndpointRequest pipeRequest = {
			.type = kUSBInterrupt,
			.direction = kUSBOut,
		};

		interruptPipe = interface->FindNextPipe(nullptr, &pipeRequest);

		IOService, IOUSBDevice, IOUSBInterface
		*/

		// to fill a servicesCriteria dictionary:
		/*
		IOServiceMatching
		IOServiceNameMatching
		IOBSDNameMatching
		*/

		// TODO not sure about these keys, but they are kind of the same as the ones I used for HID
		// this page shows a more complicated subdictionary that I might need https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/AccessingHardware/AH_Finding_Devices/AH_Finding_Devices.html#//apple_ref/doc/uid/TP30000379-BAJBGGBE
		let servicesCriteria:NSDictionary = [
			kIOHIDDeviceUsagePageKey: kHIDPage_GenericDesktop,
			kIOHIDDeviceUsageKey: kHIDUsage_GD_GamePad
		]

		var iterator:io_iterator_t = 0
		var iteratorPointer = unsafeBitCast(iterator, to: UnsafeMutablePointer<io_iterator_t>.self)

		/*var returnCode = IOServiceGetMatchingServices(
			kIOMasterPortDefault,
			servicesCriteria,
			iteratorPointer
		)*/

		// TODO check return code before proceding

		// TODO

		// or

		var notificationPort = IONotificationPortCreate(kIOMasterPortDefault)
		var runLoopSource = IONotificationPortGetRunLoopSource(notificationPort)

		CFRunLoopAddSource(
			CFRunLoopGetCurrent(),
			runLoopSource?.takeUnretainedValue(),
			CFRunLoopMode.defaultMode
		)

		// reference to self (GamePadUSBMonitor) that can be passed to c functions, essentially a pointer to void
		let serviceContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		var returnCode = IOServiceAddMatchingNotification(
			notificationPort,
			kIOPublishNotification, // there are others, not sure which one I need
			servicesCriteria,
			{(context, iteratorPointer) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadUSBMonitor.self)

				// must call another function to avoid creating a closure, which is not supported for c functions
				return caller.serviceAddedCallback()

			},
			serviceContext,
			/*notification*/ iteratorPointer // TODO not sure yet how to work with this
		)

		var quit = false

		while !quit {
			let d = IOIteratorNext(iterator)
			if d != 0 {
				IOObjectRelease(d)
			} else {
				quit = true
			}
		}

		/*
		io_object_t d;
		// Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
		while ((d = IOIteratorNext(iterator))) { IOObjectRelease(d); }

		// Also register for removal notifications
		IONotificationPortRef terminationNotificationPort = IONotificationPortCreate(kIOMasterPortDefault);
		CFRunLoopAddSource(CFRunLoopGetCurrent(),
						   IONotificationPortGetRunLoopSource(terminationNotificationPort),
						   kCFRunLoopDefaultMode);
		result = IOServiceAddMatchingNotification(terminationNotificationPort,
												  kIOTerminatedNotification,
												  matchingDict,
												  SerialPortWasRemovedFunction,
												  self,         // refCon/contextInfo
												  &portIterator);

		io_object_t d;
		// Run out the iterator or notifications won't start (you can also use it to iterate the available devices).
		while ((d = IOIteratorNext(iterator))) { IOObjectRelease(d); }
		*/

		// TODO answer this https://stackoverflow.com/questions/9918429/how-to-know-when-a-hid-usb-bluetooth-device-is-connected-in-cocoa
	}

	func serviceAddedCallback() {
		print("called")
	}

}
