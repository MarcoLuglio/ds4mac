//
//  Dualshock4Controller.swift
//  GamePad
//
//  Created by Marco Luglio on 30/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class DualShock4Controller {

	static let VENDOR_ID_SONY:Int64 = 0x054C // 1356
	static let CONTROLLER_ID_DUALSHOCK_4_USB:Int64 = 0x05C4 // 1476
	static let CONTROLLER_ID_DUALSHOCK_4_USB_V2:Int64 = 0x09CC // 2508, this controller has an led strip on its face
	static let CONTROLLER_ID_DUALSHOCK_4_BLUETOOTH:Int64 = 0x081F // 
	static let NOTIFICATION_NAME_BUTTONS = Notification.Name("DigitalButtonsChanged")
	static let NOTIFICATION_NAME_TOUCHPAD = Notification.Name("TouchpadChanged")

	static var nextId:UInt8 = 0

	let device:IOHIDDevice

	var id:UInt8 = 0

	/// contains triangle, circle, cross, square and directional pad buttons
	var mainButtons:UInt8 = 0
	var previousMainButtons:UInt8 = 0

	// top button
	var triangleButton:Bool = false
	var previousTriangleButton:Bool = false

	// right button
	var circleButton:Bool = false
	var previousCircleButton:Bool = false

	// bottom button
	var crossButton:Bool = false
	var previousCrossButton:Bool = false

	// left button
	var squareButton:Bool = false
	var previousSquareButton:Bool = false

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	/// contains the shoulder buttons, triggers (digital input), thumbstick buttons, share and options buttons
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var l1:Bool = false
	var previousL1:Bool = false
	var r1:Bool = false
	var previousR1:Bool = false
	var l2:Bool = false // there's also the analog reading for this one
	var previousL2:Bool = false
	var r2:Bool = false // there's also the analog reading for this one
	var previousR2:Bool = false

	// thumbstick buttons
	var l3:Bool = false
	var previousL3:Bool = false
	var r3:Bool = false
	var previousR3:Bool = false

	// other buttons

	var shareButton:Bool = false
	var previousShareButton:Bool = false
	var optionsButton:Bool = false
	var previousOptionsButton:Bool = false

	var psButton:Bool = false
	var previousPsButton:Bool = false

	// analog buttons

	var leftStickX:UInt8 = 0 // TODO transform to Int16
	var leftStickY:UInt8 = 0
	var rightStickX:UInt8 = 0
	var rightStickY:UInt8 = 0
	var leftTrigger:UInt8 = 0
	var rightTrigger:UInt8 = 0

	// trackpad

	var trackpadButton:Bool = false
	var previousTrackpadButton:Bool = false

	var trackpadTouch0IsActive:Bool = false
	var previousTrackpadTouch0IsActive:Bool = false
	var trackpadTouch0Id:UInt8 = 0
	var trackpadTouch0X:UInt8 = 0
	var trackpadTouch0Y:UInt8 = 0

	var trackpadTouch1IsActive:Bool = false
	var previousTrackpadTouch1IsActive:Bool = false
	var trackpadTouch1Id:UInt8 = 0
	var trackpadTouch1X:UInt8 = 0
	var trackpadTouch1Y:UInt8 = 0

	// inertial measurement unit

	var gyroX:Int16 = 0
	var gyroY:Int16 = 0
	var gyroZ:Int16 = 0

	var accelX:Int16 = 0
	var accelY:Int16 = 0
	var accelZ:Int16 = 0

	// battery

	var batteryLevel:UInt8 = 0
	var previousBatteryLevel:UInt8 = 0

	// misc

	var reportIterator:UInt8 = 0
	var previousReportIterator:UInt8 = 0

	init(_ device:IOHIDDevice) {

		self.id = DualShock4Controller.nextId
		DualShock4Controller.nextId = DualShock4Controller.nextId + 1

		self.device = device
		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		self.sendReport()
		
	}

	func parseReport(_ report:Data) {

		self.mainButtons = report[5]

		self.triangleButton = self.mainButtons & 0b10000000 == 0b10000000
		self.circleButton   = self.mainButtons & 0b01000000 == 0b01000000
		self.squareButton   = self.mainButtons & 0b00010000 == 0b00010000
		self.crossButton    = self.mainButtons & 0b00100000 == 0b00100000

		self.directionalPad = self.mainButtons & 0b00001111
		/*
		// up is reversed?? 1 is off, 0 is on?
		0=N, 1=NE, 2=E, 3=SE, 4=S, 5=SW, 6=W, 7=NW)
		dPadUp:    dPad === 0 || dPad === 1 || dPad === 7,
		dPadRight: dPad === 1 || dPad === 2 || dPad === 3,
		dPadDown:  dPad === 3 || dPad === 4 || dPad === 5,
		dPadLeft:  dPad === 5 || dPad === 6 || dPad === 7,
		*/

		self.secondaryButtons = report[6]

		self.l1            = self.secondaryButtons & 0b00000001 == 0b00000001
		self.r1            = self.secondaryButtons & 0b00000010 == 0b00000010
		self.l2            = self.secondaryButtons & 0b00000100 == 0b00000100
		self.r2            = self.secondaryButtons & 0b00001000 == 0b00001000

		self.l3            = self.secondaryButtons & 0b01000000 == 0b01000000
		self.r3            = self.secondaryButtons & 0b10000000 == 0b10000000

		self.shareButton   = self.secondaryButtons & 0b00010000 == 0b00010000
		self.optionsButton = self.secondaryButtons & 0b00100000 == 0b00100000

		self.psButton = report[7] & 0b00000001 == 0b00000001

		// analog buttons
		// origin left top
		self.leftStickX = report[1] // 0 left
		self.leftStickY = report[2] // 0 up
		self.rightStickX = report[3]
		self.rightStickY = report[4]
		self.leftTrigger = report[8] // 0 - 255
		self.rightTrigger = report[9] // 0 - 255

		// trackpad

		self.trackpadButton = report[7] & 0b00000010 == 0b00000010

		/*

		trackpad can send multiple packets per report
		it is sampled at a higher frequency

		indexes are for bluetooth, so offset by +2

		[36] 	number of trackpad packets (0x00 to 0x04)
		[37] 	packet counter

		[38] 	active low 	finger 1 id
		[39 - 41] 	finger 1 coordinates
		[42] 	active low 	finger 2 id
		[43 - 45] 	finger 2 coordinates

		[47] 	active low 	finger 1 id
		[48 - 50] 	finger 1 coordinates
		[51] 	active low 	finger 2 id
		[52 - 54] 	finger 2 coordinates
		[55] 	packet counter
		[56] 	active low 	finger 1 id
		[57 - 59] 	finger 1 coordinates
		[60] 	active low 	finger 2 id
		[61 - 63] 	finger 2 coordinates
		[64] 	packet counter
		[65] 	active low 	finger 1 id
		[66 - 68] 	finger 1 coordinates
		[69] 	active low 	finger 2 id
		[70 - 72] 	finger 2 coordinates

		*/

		let numberOfPackets = report[34]

		// 35 packets as well?

		self.trackpadTouch0IsActive = report[35] & 0b10000000 != 0b10000000 // if not active, no need to parse the rest

		/*
		cState.TrackPadTouch0.X = (short)(((ushort)(inputReport[37] & 0x0f) << 8) | (ushort)(inputReport[36]));
		cState.TrackPadTouch0.Y = (short)(((ushort)(inputReport[38]) << 4) | ((ushort)(inputReport[37] & 0xf0) >> 4));
		*/

		/*
		self.trackpadTouch0Id = report[35] & 0b01111111
		self.trackpadTouch0X = ((report[37] & 0x0f) << 8) | report[36] // TODO make this more readable
		self.trackpadTouch0Y = report[38] << 4 | ((report[37] & 0xf0) >> 4)

		self.trackpadTouch1IsActive = report[40] & 0b10000000 != 0b10000000 // if not active, no need to parse the rest
		self.trackpadTouch1Id = report[40] & 0b01111111
		self.trackpadTouch1X = ((report[41] & 0x0f) << 8) | report[40] // TODO make this more readable
		self.trackpadTouch1Y = report[42] << 4 | ((report[41] & 0xf0) >> 4)
		*/

		/*
		to move mouse

		import core graphics I guess
		func CGDisplayMoveCursorToPoint(_ display: CGDirectDisplayID, _ point: CGPoint) -> CGError
		The coordinates of a point in local display space. The origin is the upper-left corner of the specified display.
		func CGMainDisplayID() -> CGDirectDisplayID

		for multiple monitors, check finding displays https://developer.apple.com/documentation/coregraphics/quartz_display_services#1655882
		*/

		/*
		q
		byte index 	bit 7 	bit 6 	bit 5 	bit 4 	bit 3 	bit 2 	bit 1 	bit 0
		[0] 	Report ID (always 0x01)
		[10] 	Unknown, seems to count downwards, non-random pattern
		[11] 	Unknown, seems to count upwards by 3, but by 2 when [10] underflows
		[12] 	Unknown yet, 0x03 or 0x04
		*/

		// 6 bytes for gyro, and 6 bytes for accel
		/*
		int currentX = (short)((ushort)(gyro[0] << 8) | gyro[1]) / 64;
		int currentY = (short)((ushort)(gyro[2] << 8) | gyro[3]) / 64;
		int currentZ = (short)((ushort)(gyro[4] << 8) | gyro[5]) / 64;
		int AccelX = (short)((ushort)(accel[2] << 8) | accel[3]) / 256;
		int AccelY = (short)((ushort)(accel[0] << 8) | accel[1]) / 256;
		int AccelZ = (short)((ushort)(accel[4] << 8) | accel[5]) / 256;
		*/

		// I don't think this is it, the index that is shifted is too random

		/*
		accel = new Vector3(
			System.BitConverter.ToInt16(_inputBuffer, 19),
			System.BitConverter.ToInt16(_inputBuffer, 21),
			System.BitConverter.ToInt16(_inputBuffer, 23)
			)/8192f;
		*/

		// unit is radians / second when divided by 64
		self.gyroX =  (Int16(report[13] << 8) | Int16(report[14])) - 32 // / 64
		self.gyroY =  (Int16(report[15] << 8) | Int16(report[16])) - 32 // / 64
		self.gyroZ =  (Int16(report[17] << 8) | Int16(report[18])) - 32 // / 64

		// I don't think this is it, the index that is shifted is too random

		/*
		gyro = new Vector3(
			System.BitConverter.ToInt16(_inputBuffer, 13),
			System.BitConverter.ToInt16(_inputBuffer, 15),
			System.BitConverter.ToInt16(_inputBuffer, 17)
			)/1024f;
		*/

		self.accelX = (Int16(report[21] << 8) | Int16(report[22])) - 128 // / 256
		self.accelY = (Int16(report[19] << 8) | Int16(report[20])) - 128 // / 256
		self.accelZ = (Int16(report[23] << 8) | Int16(report[24])) - 128 // / 256

		// battery

		/*
		if ((this.featureSet & VidPidFeatureSet.NoBatteryReading) == 0)
		{
			tempByte = inputReport[30];
			tempCharging = (tempByte & 0x10) != 0;
			if (tempCharging != charging)
			{
				charging = tempCharging;
				ChargingChanged?.Invoke(this, EventArgs.Empty);
			}

			maxBatteryValue = charging ? BATTERY_MAX_USB : BATTERY_MAX;
			tempBattery = (tempByte & 0x0f) * 100 / maxBatteryValue;
			tempBattery = Math.Min(tempBattery, 100);
			if (tempBattery != battery)
			{
				battery = tempBattery;
				BatteryChanged?.Invoke(this, EventArgs.Empty);
			}

			cState.Battery = (byte)battery;
			//System.Diagnostics.Debug.WriteLine("CURRENT BATTERY: " + (inputReport[30] & 0x0f) + " | " + tempBattery + " | " + battery);
			if (tempByte != priorInputReport30)
			{
				priorInputReport30 = tempByte;
				//Console.WriteLine(MacAddress.ToString() + " " + System.DateTime.UtcNow.ToString("o") + "> power subsystem octet: 0x" + inputReport[30].ToString("x02"));
			}
		}
		else
		{
			// Some gamepads don't send battery values in DS4 compatible data fields, so use dummy 99% value to avoid constant low battery warnings
			priorInputReport30 = 0x0F;
			battery = 99;
			cState.Battery = 99;
		}
		*/

		self.batteryLevel = report[12] // read somewhere that sometimes it is 0-9, sometimes it is 1-10 //

		self.reportIterator = report[7] >> 2 // [7] 	Counter (counts up by 1 per report), I guess this is only relevant to bluetooth

		if self.previousMainButtons != self.mainButtons
			|| self.previousSecondaryButtons != self.secondaryButtons
			|| self.previousBatteryLevel != self.batteryLevel
			|| self.previousPsButton != self.psButton
			|| self.previousTrackpadButton != self.trackpadButton
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: DualShock4Controller.NOTIFICATION_NAME_BUTTONS,
					object: GamePadButtonChangedNotification(
						leftButton: self.l1,
						rightButton: self.r1
					)
				)
			}

			self.previousMainButtons = self.mainButtons

			self.previousSquareButton = self.squareButton
			self.previousCrossButton = self.crossButton
			self.previousCircleButton = self.circleButton
			self.previousTriangleButton = self.triangleButton

			self.previousDirectionalPad = self.directionalPad

			self.previousSecondaryButtons = self.secondaryButtons

			self.previousL1 = self.l1
			self.previousR1 = self.r1
			self.previousL2 = self.l2
			self.previousR2 = self.r2
			self.previousL3 = self.l3
			self.previousR3 = self.r3

			self.previousShareButton = self.shareButton
			self.previousOptionsButton = self.optionsButton

			self.previousBatteryLevel = self.batteryLevel
			self.previousPsButton = self.psButton
			self.previousTrackpadButton = self.trackpadButton

		}

		if previousTrackpadTouch0IsActive != trackpadTouch0IsActive
			|| previousTrackpadTouch1IsActive != trackpadTouch1IsActive
		{

			NotificationCenter.default.post(
				name: DualShock4Controller.NOTIFICATION_NAME_TOUCHPAD,
				object: GamePadTouchpadChangedNotification()
			)

			previousTrackpadTouch0IsActive = trackpadTouch0IsActive
			previousTrackpadTouch1IsActive = trackpadTouch1IsActive

		}

		//self.sendReport()

	}

	func sendReport() {

		//let toggleMotor:UInt8 = 0xf0 // 0xf0 disable 0xf3 enable or 0b00001111 // enable unknown, flash, color, rumble
		let rightLightFastRumble:UInt8 = 0x00 // weak motor 1-255
		let leftHeavySlowRumble:UInt8 = 0x00 // strong motor 1-255
		let red:UInt8 = 0x0F
		let green:UInt8 = 0x00
		let blue:UInt8 = 0x0F
		let flashOn:UInt8 = 0x00 // flash on duration
		let flashOff:UInt8 = 0x00 // flash off duration
		let bluetoothOffset = 2

		var dualshock4ControllerInputReportUSB = [UInt8](repeating: 0, count: 11)

		dualshock4ControllerInputReportUSB[0] = 0x05;
		// enable rumble (0x01), lightbar (0x02), flash (0x04) 0b00000111
		dualshock4ControllerInputReportUSB[1] = 0xf7; // 0b11110111
		dualshock4ControllerInputReportUSB[2] = 0x04;
		dualshock4ControllerInputReportUSB[4] = rightLightFastRumble;
		dualshock4ControllerInputReportUSB[5] = leftHeavySlowRumble;
		dualshock4ControllerInputReportUSB[6] = red;
		dualshock4ControllerInputReportUSB[7] = green;
		dualshock4ControllerInputReportUSB[8] = blue;
		dualshock4ControllerInputReportUSB[9] = flashOn;
		dualshock4ControllerInputReportUSB[10] = flashOff;

		//var dualshock4ControllerInputReportBluetooth = [UInt8](repeating: 0, count: 74)

		/*dualshock4ControllerInputReportBluetooth[0] = 0x15; // 0x11
		dualshock4ControllerInputReportBluetooth[1] = (0xC0 | btPollRate) // (0x80 | btPollRate); // input report rate
		// enable rumble (0x01), lightbar (0x02), flash (0x04)
		dualshock4ControllerInputReportBluetooth[2] = 0xA0;
		dualshock4ControllerInputReportBluetooth[3] = 0xf7;
		dualshock4ControllerInputReportBluetooth[4] = 0x04;
		dualshock4ControllerInputReportBluetooth[4 + bluetoothOffset] = rightLightFastRumble;
		dualshock4ControllerInputReportBluetooth[5 + bluetoothOffset] = leftHeavySlowRumble;
		dualshock4ControllerInputReportBluetooth[6 + bluetoothOffset] = red;
		dualshock4ControllerInputReportBluetooth[7 + bluetoothOffset] = green;
		dualshock4ControllerInputReportBluetooth[8 + bluetoothOffset] = blue;
		dualshock4ControllerInputReportBluetooth[9 + bluetoothOffset] = flashOn;
		dualshock4ControllerInputReportBluetooth[10 + bluetoothOffset] = flashOff;*/

		/*let dualshock4ControllerInputReportBluetoothCRC = CRC32.checksum(bytes: dualshock4ControllerInputReportBluetooth)
		dualshock4ControllerInputReportBluetooth.append(contentsOf: dualshock4ControllerInputReportBluetoothCRC)*/

		print("size of report: \(dualshock4ControllerInputReportUSB.count)")

		IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			0x01,
			dualshock4ControllerInputReportUSB,
			dualshock4ControllerInputReportUSB.count
		)

	}

}
