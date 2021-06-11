//
//  Xbox360Controller.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class XboxOneController {

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

	// battery

	var cableConnected = false // TODO xbox one is able to tell usb from ac?
	var batteryCharging = false
	var batteryLevel:UInt8 = 0 // 0 to 3
	var previousBatteryLevel:UInt8 = 0

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

		//self.sendInitReport()

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: XboxOneChangeRumbleNotification.Name,
				object: nil
			)

		// self.sendRumbleReport(leftHeavySlowRumble: 30, rightLightFastRumble: 50, leftTriggerRumble: 0, rightTriggerRumble: 0)

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		// for xbox one
		// type ?, id ?, length 17 bytes

		// report[0] // always 0x01

		// baterry?
		if report[0] == 0x04 || report.count == 2 {

			print("report[0] \(report[0])")
			print("report[1] \(String(report[1], radix: 2))") // 10000111 what is the first bit??

			/*
			0b000_0100 battery
			0b000_1000 pnc (what is that??)
			0b000_0000 usb
			*/

			if report[1] & 0b0000_1100 != 0b000_0100 {
				self.cableConnected = true
			}
			self.batteryCharging = report[1] & 0b001_0000 == 0b001_0000
			self.batteryLevel = report[1] & 0b0000_0011

			if self.previousBatteryLevel != self.batteryLevel {

				self.previousBatteryLevel = self.batteryLevel

				DispatchQueue.main.async {
					NotificationCenter.default.post(
						name: GamepadBatteryChangedNotification.Name,
						object: GamepadBatteryChangedNotification(
							battery: self.batteryLevel,
							batteryMin: 0,
							batteryMax: 3,
							isConnected: self.cableConnected,
							isCharging: self.batteryCharging
						)
					)
				}

			}

			return

		}

		if report[0] != 0x01 || report.count < 17 {
			print("report[0] \(report[0])")
			print("report.count \(report.count)")
			return
		}

		/*
		// the xbox button has its own special report
		if (data[0] == 0X07) {
			/*
			 * The Xbox One S controller requires these reports to be
			 * acked otherwise it continues sending them forever and
			 * won't report further mode button events.
			 */
			if (data[1] == 0x30)
				xpadone_ack_mode_report(xpad, data[2]);

			input_report_key(dev, BTN_MODE, data[4] & 0x01);
			input_sync(dev);
			return;
		}
		// check invalid packet
		else if (data[0] != 0X20)
			return;

		0x03: Heartbeat

		struct XboxOneHeartbeatData{
			uint8_t type;
			uint8_t const_20;
			uint16_t id;

			uint8_t dummy_const_80;
			uint8_t first_after_controller;
			uint8_t dummy1;
			uint8_t dummy2;
		};

		0x07: Guide button status

		Sent when guide button status changes.

		struct XboxOneGuideData{
			uint8_t type;
			uint8_t const_20;
			uint16_t id;

			uint8_t down;
			uint8_t dummy_const_5b;
		};


		// we are taking care of the battery report ourselves
		if (xdata->battery.report_id && report->id == xdata->battery.report_id && reportsize == 2) {
			xpadneo_update_psy(xdata, data[1]);
			return -1;
		}

		#define XPADNEO_PSY_ONLINE(data)     ((data&0x80)>0) 0b0000_1000 power supply online
		#define XPADNEO_PSY_MODE(data)       ((data&0x0C)>>2) 0b0000_1100 >> 2

		#define XPADNEO_POWER_USB(data)      (XPADNEO_PSY_MODE(data)==0)
		#define XPADNEO_POWER_BATTERY(data)  (XPADNEO_PSY_MODE(data)==1)
		#define XPADNEO_POWER_PNC(data)      (XPADNEO_PSY_MODE(data)==2)

		#define XPADNEO_BATTERY_ONLINE(data)         ((data&0x0C)>0) 0b0000_1100 > 0
		#define XPADNEO_BATTERY_CHARGING(data)       ((data&0x10)>0) 0b0001_0000 > 0

		#define XPADNEO_BATTERY_CAPACITY_LEVEL(data) (data&0x03) 0b000_0011

		static int capacity_level_map[] = {
			[0] = POWER_SUPPLY_CAPACITY_LEVEL_LOW,
			[1] = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL,
			[2] = POWER_SUPPLY_CAPACITY_LEVEL_HIGH,
			[3] = POWER_SUPPLY_CAPACITY_LEVEL_FULL,
		};
		*/

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
		// Even though 2 bytes are reserved for the triggers, the report never has a value greater than 255
		self.leftTrigger  = UInt16(report[10] << 8) | UInt16(report[9])
		self.rightTrigger = UInt16(report[12] << 8) | UInt16(report[11])

		self.leftTriggerButton = self.leftTrigger > 0 // TODO improve this with a getter and or deadzone
		self.rightTriggerButton = self.rightTrigger > 0 // TODO improve this with a getter and or deadzone

		if self.previousMainButtons != self.mainButtons
			|| self.previousSecondaryButtons != self.secondaryButtons
			|| self.previousDirectionalPad != self.directionalPad
			|| self.previousViewButton != self.viewButton
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
						stickMax: UInt16.max,
						leftTrigger: self.leftTrigger,
						rightTrigger: self.rightTrigger,
						triggerMax: UInt16(UInt8.max)
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

	// MARK: - Output reports

	@objc func changeRumble(_ notification:Notification) {

		let o = notification.object as! XboxOneChangeRumbleNotification

		sendRumbleReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble,
			leftTriggerRumble: o.leftTriggerRumble,
			rightTriggerRumble: o.rightTriggerRumble
		)

	}

	private func sendRumbleReport(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8, leftTriggerRumble:UInt8, rightTriggerRumble:UInt8) {

		/*

		packet->data[0] = 0x09; /* activate rumble */
		packet->data[1] = 0x00;
		packet->data[2] = xpad->odata_serial++;
		packet->data[3] = 0x09;
		packet->data[4] = 0x00;
		packet->data[5] = 0x0F;
		packet->data[6] = 0x00;
		packet->data[7] = 0x00;
		packet->data[8] = strong / 512;	/* left actuator */
		packet->data[9] = weak / 512;	/* right actuator */
		packet->data[10] = 0xFF; /* on period */
		packet->data[11] = 0x00; /* off period */
		packet->data[12] = 0xFF; /* repeat count */





		0x09: Activate rumble

		buffer[0] = 0x09;
		buffer[1] = 0x08; // 0x20 bit and all bits of 0x07 prevents rumble effect.
		buffer[2] = 0x00; // This may have something to do with how many times effect is played
		buffer[3] = 0x??; // Substructure (what substructure rest of this packet has)

		If you send too long packet, overflown data is ignored. If you send too short packet, missing values are considered as 0.

		Buffer[3] defines what the rest of this packets is:

		Continous rumble effect

		buffer[3] = 0x08; // Substructure (what substructure rest of this packet has)
		buffer[4] = 0x00; // Mode
		buffer[5] = 0x0f; // Rumble mask (what motors are activated) (0000 lT rT L R)
		buffer[6] = 0x04; // lT force
		buffer[7] = 0x04; // rT force
		buffer[8] = 0x20; // L force
		buffer[9] = 0x20; // R force
		buffer[10] = 0x80; // Length of pulse
		buffer[11] = 0x00; // Period between pulses

		Single rumble effect

		buffer[3] = 0x09; // Substructure (what substructure rest of this packet has)
		buffer[4] = 0x00; // Mode
		buffer[5] = 0x0f; // Rumble mask (what motors are activated) (0000 lT rT L R)
		buffer[6] = 0x04; // lT force
		buffer[7] = 0x04; // rT force
		buffer[8] = 0x20; // L force
		buffer[9] = 0x20; // R force
		buffer[10] = 0x80; // Length of pulse

		Play effect

		buffer[3] = 0x04; // Substructure (what substructure rest of this packet has)
		buffer[4] = 0x00; // Mode
		buffer[5] = 0x0f; // Rumble mask (what motors are activated) (0000 lT rT L R)
		buffer[6] = 0x04; // lT force ?
		buffer[7] = 0x04; // rT force ?

		Short rumble packet

		buffer[3] = 0x02; // Substructure (what substructure rest of this packet has)
		buffer[4] = 0x00; // Mode
		buffer[5] = 0x0f; // Rumble mask (what motors are activated) (0000 lT rT L R) ?
		buffer[6] = 0x04; // lT force ?
		buffer[7] = 0x04; // rT force ?

		List of different modes

			0x00: Normal
			0x20: Normal, but sometimes prevents rest of 0x00 mode effects
			0x40: Triggerhell (= Pressing trigger starts rumbling all motors fast. I assume there is way to upload some pattern here, but don't know how.)
			0x41: Trigger effect (if substructure = 4?) (= Pressing trigger causes single rumble effect)(if buffer[6] >= 0x0b this rumble effect can be played multiple times. if buffer[6] > 0x4F this doesn't work)
			0x42: Fast + short rumble once

		0x07: Load rumble effect

		buffer[0] = 0x07,
		buffer[1] = 0x85, // At least one of 0x07 bits must be on
		buffer[2] = 0xa0, // Dummy ?
		buffer[3] = 0x20, // L force
		buffer[4] = 0x20, // R force
		buffer[5] = 0x30, // length
		buffer[6] = 0x20, // period
		buffer[7] = 0x02, // Effect extra play count (0x02 means that effect is played 1+2 times)
		buffer[8] = 0x00, // Dummy ?

		*/

		/// Rumble mask (what motors are activated) (0000 left trigger, right trigger, left, right)
		var rumbleMask:UInt8 = 0

		if leftHeavySlowRumble > 0 {
			rumbleMask = rumbleMask | 0b000_0010
		}

		if rightLightFastRumble > 0 {
			rumbleMask = rumbleMask | 0b000_0001
		}

		if leftTriggerRumble > 0 {
			rumbleMask = rumbleMask | 0b000_1000
		}

		if rightTriggerRumble > 0 {
			rumbleMask = rumbleMask | 0b000_0100
		}

		let xboxOneControllerRumbleOutputReport:[UInt8] = [
			0x09,
			0x08, // 0x20 bit and all bits of 0x07 prevents rumble effect.
			0x00,
			0x09, // substructure 9
			0x00, // simple mode
			rumbleMask,
			leftTriggerRumble,
			rightTriggerRumble,
			leftHeavySlowRumble,
			rightLightFastRumble,
			0x01, // on period - what is the unit of measurement?
			0x00, // off period
			0x00 // repeat count
		]

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
			0x09, // report id
			xboxOneControllerRumbleOutputReport,
			xboxOneControllerRumbleOutputReportLength
		)

	}

	/*
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
	*/

}
