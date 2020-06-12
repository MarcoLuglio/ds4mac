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

	var xbox360Controller:Xbox360Controller!
	var dualShock4Controller:DualShock4Controller!

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
			hidContext // reference to self that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
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
			hidContext // reference to self that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
		)

		//IOHIDManagerRegisterInputValueCallback(<#T##manager: IOHIDManager##IOHIDManager#>, <#T##callback: IOHIDValueCallback?##IOHIDValueCallback?##(UnsafeMutableRawPointer?, IOReturn, UnsafeMutableRawPointer?, IOHIDValue) -> Void#>, <#T##context: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)

		IOHIDManagerRegisterInputReportCallback(
			hidManager,
			{(context, result, sender, reportType, reportID, reportPointer, reportLength) in

				// restoring the swift type of the pointer to void
				let caller = unsafeBitCast(context, to: GamePadMonitor.self)

				/*print(NSDate())
				print(reportType)
				print(reportID)
				print(reportLength)*/

				//let report = unsafeBitCast(reportPointer, to: [UInt8].self) // TODO
				//var report = [Int16](repeating: 0, count: reportLength)
				//(report as NSData).getBytes(&bytes1, length: length)
				//var report = NSData(bytes:reportPointer, length: reportLength)
				let report = Data(bytes:reportPointer, count:reportLength)

				// UnsafeMutablePointer<UInt8>

				//report.wit
				//report.withUnsafeBufferPointer() { (cArray: UnsafePointer<Float>) -> () in
					// do something with the C array
				//}

				// must call another function to avoid creating a closure, which is not supported for c functions
				return caller.inputReportCallback(result:result, sender:sender!, reportType:reportType, reportID:reportID, report:report)

			},
			hidContext  // reference to self that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
		)

		RunLoop.current.run()

	}

	// MARK: HID Manager callbacks

	func hidDeviceAddedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// reference to self that can be passed to c functions, essentially a pointer to void
		let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		// TODO this might be the only way to specify which device sent what
		/*IOHIDDeviceRegisterInputReportCallback(
			device,
			report, // Pointer to preallocated buffer in which to copy inbound report data.
			0, //reportLength, // lenght of preallocated buffer
			{() in
				//
			},
			hidContext  // reference to self that can be passed to c functions, essentially a pointer to void, meaning it can point to any type
		)*/

		let productName = IOHIDDeviceGetProperty(device, kIOHIDProductKey as CFString);
		let productID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDProductIDKey as CFString) as! Int64;
		let vendorName = IOHIDDeviceGetProperty(device, kIOHIDManufacturerKey as CFString);
		let vendorID:Int64 = IOHIDDeviceGetProperty(device, kIOHIDVendorIDKey as CFString) as! Int64;

		print(productName!) // Xbox 360 Wired Controller
		print(vendorName!) // ©Microsoft Corporation

		if vendorID == Xbox360Controller.VENDOR_ID_MICROSOFT && productID == Xbox360Controller.CONTROLLER_ID_XBOX_360 {
			self.xbox360Controller = Xbox360Controller(device)
		} else if vendorID == DualShock4Controller.VENDOR_ID_SONY
			&& (productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_USB || productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_USB_V2 || productID == DualShock4Controller.CONTROLLER_ID_DUALSHOCK_4_BLUETOOTH)
		{
			self.dualShock4Controller = DualShock4Controller(device)
		}

	}

	func hidDeviceRemovedCallback(_ result:IOReturn, sender:UnsafeMutableRawPointer, device:IOHIDDevice) {

		// reference to self that can be passed to c functions, essentially a pointer to void
		// let hidContext = unsafeBitCast(self, to: UnsafeMutableRawPointer.self)

		// TODO not sure what to do here

	}

	/// Data input report callback
	func inputReportCallback(result:IOReturn, sender:Any, reportType:IOHIDReportType, reportID:UInt32, report:Data) {

		/*
		Sony "official" driver maintained by Sony employee:
		https://github.com/torvalds/linux/blob/master/drivers/hid/hid-sony.c


		Structure HID transaction (portion)

		Input and output reports specify control data and feature reports specify configuration data.

		Data Format

		|----------|-----|-----|-----|-----|-----|-----|-----|-------|
		|byte index|bit 7|bit 6|bit 5|bit 4|bit 3|bit 2|bit 1|bit 0  |
		|----------|-----|-----|-----|-----|-----|-----|-----|-------|
		|[0]       |transaction type:      |parameters:|report type: |
		|          |                       |           |             |
		|          |0x04: GET REPORT       |0x00       |0x01: input  |
		|          |0x05: SET REPORT       |0x01       |0x02: output |
		|          |0x0A: DATA             |0x02       |0x03: feature|
		|----------|-----|-----|-----|-----|-----|-----|-----|-------|

		to calibrate ds4

		ds4windows does this, though it is a bit hard to follow

		0x03
		The transaction type is SET REPORT (0x05), and the report type is FEATURE (0x03). The protocol code is 0x03.
		Most bytes from index 4 change between two reports.
		Report example:

		0x53, 0x03, 0x02, 0x00, 0xf1, 0xdf, 0xd3, 0x7b, 0x4f, 0x49, 0x0b, 0x0b, 0x7c, 0x79, 0xde, 0xad,
		0x5d, 0xa3, 0x41, 0x8a, 0x9c, 0x2e, 0xaf, 0x09, 0xc4, 0xa6, 0x80, 0xb4, 0x82, 0x87, 0x2c, 0xbf,
		0x86, 0xe0, 0x2a, 0x86, 0x60, 0xa0, 0x23, 0x33

		Data Format byte index 	bit 7 	bit 6 	bit 5 	bit 4 	bit 3 	bit 2 	bit 1 	bit 0
		[0] 	0x05 	0x00 	0x03
		[1] 	0x03
		[2] 	sequence counter (init = 0x02, step = 1)
		[3] 	0x00
		[4 - 35] 	TODO, work in progress.
		[36 - 39] 	CRC-32 of the previous bytes.

		There is a periodic report sequence that consists in 5 0xf0 SET FEATURE reports, 2 0xf2 GET FEATURE reports, and 19 0xf1 GET FEATURE REPORTS. Each sequence takes about 30 seconds, and a new sequence starts about 30 seconds after the end of the last one. There is 1 second between two reports sent by the PS4.

		There is another periodic report sequence that consists in one 0x03 SET FEATURE report and 1 0x04 GET FEATURE report. A new sequence starts about 30 seconds after the end of the last one. The 0x03 SET FEATURE report is sent 5 seconds after the 0x04 GET FEATURE report.

		These two periodic sequences seem to be independent as they do not have the same period, and they have two distinct sequence counters.

		* The default behavior of the Dualshock 4 is to send reports using
		* report type 1 when running over Bluetooth. However, when feature
		* report 2 is requested during the controller initialization it starts
		* sending input reports in report 17. Since report 17 is undefined
		* in the default HID descriptor, the HID layer won't generate events.
		* While it is possible (and this was done before) to fixup the HID
		* descriptor to add this mapping, it was better to do this manually.
		* The reason is there were various pieces software both open and closed
		* source, relying on the descriptors to be the same across various
		* operating systems. If the descriptors wouldn't match some
		* applications e.g. games on Wine would not be able to function due
		* to different descriptors, which such applications are not parsing.

		Check https://patchwork.kernel.org/patch/9467479/ for functional example besides the DS4Windows

		// I think report id is what the psdevwiki calls protocol code
		// for calibrating the device, it is 0x05 and the length is 41
		// var ioReturn = IOHIDDeviceGetReport(device, kIOHIDReportTypeFeature, reportId:CFIndex, report:UnsafePointer<UInt8>, reportLength:CFIndex)
		// var ioReturn = IOHIDDeviceSetReport(device, , kIOHIDReportTypeFeature, reportId:CFIndex, report:UnsafePointer<UInt8>, reportLength:CFIndex)
		*/

		// for xbox 360
		// type 0, id 0, length 20 bytes

		// for ds4
		// type 0, id 1, length 64 bytes

		if report.count == 14 { // TODO xbox360, improve this later, maybe by checking the sender?
			self.xbox360Controller.parseReport(report)
		} else if report.count == 64 { // TODO ds4, improve this later, maybe checking the sender?
			self.dualShock4Controller.parseReport(report)
		} else {
			print("report id: \(String(reportID, radix: 16))")
			print ("report size: \(report.count)")
		}

	}

}



// stuff for device input that I'm not using

/*

IOHIDDeviceRegisterInputValueCallback(
	device,
	{(context, result, sender, deviceValue) in

		// restoring the swift type of the pointer to void
		let caller = unsafeBitCast(context, to: GamePadMonitor.self)

		caller.hidDeviceInputCallback(result, sender:sender!, deviceValue: deviceValue)

	},
	hidContext
)

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

*/




// stuff for device added that I'm not using

/*

/*IOHIDDeviceSetValueWithCallback(
	//
)

IOHIDDeviceSetValueMultipleWithCallback(
	//
)
*/

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


*/
