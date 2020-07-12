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
	static let CONTROLLER_ID_DUALSHOCK_4_USB_V2:Int64 = 0x09CC // 2508, this controller has an led strip above the trackpad
	static let CONTROLLER_ID_DUALSHOCK_4_BLUETOOTH:Int64 = 0x081F //

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	let productID:Int64
	let transport:String

	let device:IOHIDDevice

	var isBluetooth = false
	var enableIMUReport = false

	/// Used for inertial measurement calculations (gyro and accel)

	var time:Date = Date()
	var previousTime:Date = Date()
	var timeInterval:TimeInterval = 0

	var reportTime:Int32 = 0
	var previousReportTime:Int32 = 0
	var reportTimeInterval:Int32 = 0

	/// contains triangle, circle, cross, square and directional pad buttons
	var mainButtons:UInt8 = 0
	var previousMainButtons:UInt8 = 0

	// top button
	var triangleButton = false
	var previousTriangleButton = false

	// right button
	var circleButton = false
	var previousCircleButton = false

	// bottom button
	var crossButton = false
	var previousCrossButton = false

	// left button
	var squareButton = false
	var previousSquareButton = false

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	/// contains the shoulder buttons, triggers (digital input), thumbstick buttons, share and options buttons
	var secondaryButtons:UInt8 = 0
	var previousSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var l1 = false
	var previousL1 = false
	var r1 = false
	var previousR1 = false
	/// digital reading for left trigger
	/// for the analog reading see leftTrigger
	var l2 = false
	var previousL2 = false
	/// digital reading for right trigger
	/// for the analog reading see rightTrigger
	var r2 = false
	var previousR2 = false

	// thumbstick buttons
	var l3 = false
	var previousL3 = false
	var r3 = false
	var previousR3 = false

	// other buttons

	var shareButton = false
	var previousShareButton = false
	var optionsButton = false
	var previousOptionsButton = false

	var psButton = false
	var previousPsButton = false

	// analog buttons

	var leftStickX:UInt8 = 0 // TODO transform to Int16 because of xbox? or do this in the notification?
	var previousLeftStickX:UInt8 = 0
	var leftStickY:UInt8 = 0
	var previousLeftStickY:UInt8 = 0
	var rightStickX:UInt8 = 0
	var previousRightStickX:UInt8 = 0
	var rightStickY:UInt8 = 0
	var previousRightStickY:UInt8 = 0

	var leftTrigger:UInt8 = 0
	var previousLeftTrigger:UInt8 = 0
	var rightTrigger:UInt8 = 0
	var previousRightTrigger:UInt8 = 0

	// trackpad

	var trackpadButton = false
	var previousTrackpadButton = false

	var trackpadTouch0IsActive = false
	var previousTrackpadTouch0IsActive = false
	var trackpadTouch0Id:UInt8 = 0
	var trackpadTouch0X:UInt8 = 0
	var trackpadTouch0Y:UInt8 = 0

	var trackpadTouch1IsActive = false
	var previousTrackpadTouch1IsActive = false
	var trackpadTouch1Id:UInt8 = 0
	var trackpadTouch1X:UInt8 = 0
	var trackpadTouch1Y:UInt8 = 0

	// inertial measurement unit

	var gyroX:Float32 = 0
	var gyroY:Float32 = 0
	var gyroZ:Float32 = 0

	var accelX:Float32 = 0
	var accelY:Float32 = 0
	var accelZ:Float32 = 0

	//var rotationZ:Float32 = 0

	// battery

	var cableConnected = false
	var batteryCharging = false
	var batteryLevel:UInt8 = 0 // 0 to 9 on USB, 0 - 10 on Bluetooth
	var previousBatteryLevel:UInt8 = 0

	// misc

	var reportIterator:UInt8 = 0
	var previousReportIterator:UInt8 = 0

	init(_ device:IOHIDDevice, productID:Int64, transport:String, enableIMUReport:Bool) {

		self.id = DualShock4Controller.nextId
		DualShock4Controller.nextId = DualShock4Controller.nextId + 1

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID
		self.device = device
		self.enableIMUReport = enableIMUReport

		IOHIDDeviceOpen(self.device, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeRumble),
				name: DualShock4ChangeRumbleNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.changeLed),
				name: DualShock4ChangeLedNotification.Name,
				object: nil
			)

		if self.enableIMUReport {
			self.requestCalibrationDataReport()
		}

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

		*/

	}

	// MARK: - Input reports

	/*public private(set) var gyroZ:Float32 {

		get {
			return self._gyroZ
		}

		set(newValue) {

			var newGyroZ = newValue

			if newGyroZ > 128 {
				newGyroZ = newGyroZ - 255
			}
			//newGyroZ /= 64.0 // according to joyshock, unit is radians / second when divided by 64, need the timestamp

			self._gyroZ = newGyroZ
			self.rotationZ += self._gyroZ
		}

	}*/

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		self.previousTime = self.time
		self.time = Date()
		self.timeInterval = self.time.timeIntervalSince(self.previousTime) * 1_000_000

		let bluetoothOffset = self.isBluetooth ? 2 : 0

		self.mainButtons = report[5 + bluetoothOffset]

		self.triangleButton = self.mainButtons & 0b10000000 == 0b10000000
		self.circleButton   = self.mainButtons & 0b01000000 == 0b01000000
		self.squareButton   = self.mainButtons & 0b00010000 == 0b00010000
		self.crossButton    = self.mainButtons & 0b00100000 == 0b00100000

		self.directionalPad = self.mainButtons & 0b00001111
		/*
		self.upButton: (self.directionalPad == 0 || self.directionalPad == 1 || self.directionalPad == 7),
		self.rightButton: (self.directionalPad == 2 || self.directionalPad == 1 || self.directionalPad == 3),
		self.downButton: (self.directionalPad == 4 || self.directionalPad == 3 || self.directionalPad == 5),
		self.leftButton: (self.directionalPad == 6 || self.directionalPad == 5 || self.directionalPad == 7),
		*/

		self.secondaryButtons = report[6 + bluetoothOffset]

		self.l1            = self.secondaryButtons & 0b00000001 == 0b00000001
		self.r1            = self.secondaryButtons & 0b00000010 == 0b00000010
		self.l2            = self.secondaryButtons & 0b00000100 == 0b00000100
		self.r2            = self.secondaryButtons & 0b00001000 == 0b00001000

		self.l3            = self.secondaryButtons & 0b01000000 == 0b01000000
		self.r3            = self.secondaryButtons & 0b10000000 == 0b10000000

		self.shareButton   = self.secondaryButtons & 0b00010000 == 0b00010000
		self.optionsButton = self.secondaryButtons & 0b00100000 == 0b00100000

		self.psButton = report[7 + bluetoothOffset] & 0b00000001 == 0b00000001

		self.reportIterator = report[7 + bluetoothOffset] >> 2 // [7] 	Counter (counts up by 1 per report), I guess this is only relevant to bluetooth

		if self.previousMainButtons != self.mainButtons
			|| self.previousSecondaryButtons != self.secondaryButtons
			|| self.previousPsButton != self.psButton
			|| self.previousTrackpadButton != self.trackpadButton
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamePadButtonChangedNotification.Name,
					object: GamePadButtonChangedNotification(
						leftTriggerButton: self.l2,
						leftShoulderButton: self.l1,
						minusButton:false,
						leftSideTopButton:false,
						leftSideBottomButton:false,
						upButton: (self.directionalPad == 0 || self.directionalPad == 1 || self.directionalPad == 7),
						rightButton: (self.directionalPad == 2 || self.directionalPad == 1 || self.directionalPad == 3),
						downButton: (self.directionalPad == 4 || self.directionalPad == 3 || self.directionalPad == 5),
						leftButton: (self.directionalPad == 6 || self.directionalPad == 5 || self.directionalPad == 7),
						socialButton: self.shareButton,
						leftStickButton: self.l3,
						trackPadButton: self.trackpadButton,
						centralButton: self.psButton,
						rightStickButton: self.r3,
						rightAuxiliaryButton: self.optionsButton,
						faceNorthButton: self.triangleButton,
						faceEastButton: self.circleButton,
						faceSouthButton: self.crossButton,
						faceWestButton: self.squareButton,
						rightSideBottomButton:false,
						rightSideTopButton:false,
						plusButton:false,
						rightShoulderButton: self.r1,
						rightTriggerButton: self.r2
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

			self.previousPsButton = self.psButton
			self.previousTrackpadButton = self.trackpadButton

		}

		// analog buttons
		// origin left top
		self.leftStickX = report[1 + bluetoothOffset] // 0 left
		self.leftStickY = report[2 + bluetoothOffset] // 0 up
		self.rightStickX = report[3 + bluetoothOffset]
		self.rightStickY = report[4 + bluetoothOffset]
		self.leftTrigger = report[8 + bluetoothOffset] // 0 - 255
		self.rightTrigger = report[9 + bluetoothOffset] // 0 - 255

		if self.previousLeftStickX != self.leftStickX
			|| self.previousLeftStickY != self.leftStickY
			|| self.previousRightStickX != self.rightStickX
			|| self.previousRightStickY != self.rightStickY
			|| self.previousLeftTrigger != self.leftTrigger
			|| self.previousRightTrigger != self.rightTrigger
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamePadAnalogChangedNotification.Name,
					object: GamePadAnalogChangedNotification(
						leftStickX: Int16(self.leftStickX),
						leftStickY: Int16(self.leftStickY),
						rightStickX: Int16(self.rightStickX),
						rightStickY: Int16(self.rightStickY),
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

		// trackpad

		self.trackpadButton = report[7 + bluetoothOffset] & 0b00000010 == 0b00000010

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

		if report.count < 11 {
			return
		}

		self.previousReportTime = self.reportTime
		self.reportTime = (Int32(report[11 + bluetoothOffset]) << 8 | Int32(report[10 + bluetoothOffset])) // this is little endian
		self.reportTimeInterval = self.reportTime - self.previousReportTime
		if self.reportTimeInterval < 0 {
			self.reportTimeInterval += UINT16_MAX
		}

		let numberOfPackets = report[34 + bluetoothOffset]

		// 35 packets as well?

		self.trackpadTouch0IsActive = report[35 + bluetoothOffset] & 0b10000000 != 0b10000000 // if not active, no need to parse the rest

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

		if previousTrackpadTouch0IsActive != trackpadTouch0IsActive
			|| previousTrackpadTouch1IsActive != trackpadTouch1IsActive
		{

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamePadTouchpadChangedNotification.Name,
					object: GamePadTouchpadChangedNotification(
						//
					)
				)
			}

			previousTrackpadTouch0IsActive = trackpadTouch0IsActive
			previousTrackpadTouch1IsActive = trackpadTouch1IsActive

		}

		// TODO IMU

		/*
		gyros and accelerometers need to be calibrated based on the feature report (we receive before the inpur reports start coming):
		#define DS4_FEATURE_REPORT_0x02_SIZE 37
		#define DS4_FEATURE_REPORT_0x05_SIZE 41
		#define DS4_FEATURE_REPORT_0x81_SIZE 7
		#define DS4_INPUT_REPORT_0x11_SIZE 78
		#define DS4_OUTPUT_REPORT_0x05_SIZE 32

		linux driver uses Default to 4ms poll interval, which is same as USB (not adjustable).
		#define DS4_BT_DEFAULT_POLL_INTERVAL_MS 4
		#define DS4_BT_MAX_POLL_INTERVAL_MS 62
		#define DS4_GYRO_RES_PER_DEG_S 1024
		#define DS4_ACC_RES_PER_G      8192

		Used for calibration of DS4 accelerometer and gyro.
		struct ds4_calibration_data {
			int abs_code;
			short bias;
			* Calibration requires scaling against a sensitivity value, which is a
			 * float. Store sensitivity as a fraction to limit floating point
			 * calculations until final calibration.
			 *
			int sens_numer;
			int sens_denom;
		};

		linux sony-hid-c

		static void dualshock4_parse_report(struct sony_sc *sc, u8 *rd, int size)
		{
			/* Convert timestamp (in 5.33us unit) to timestamp_us */
			offset = data_offset + DS4_INPUT_REPORT_TIMESTAMP_OFFSET;
			timestamp = get_unaligned_le16(&rd[offset]);
			if (!sc->timestamp_initialized) {
				sc->timestamp_us = ((unsigned int)timestamp * 16) / 3;
				sc->timestamp_initialized = true;
			} else {
				u16 delta;

				if (sc->prev_timestamp > timestamp)
					delta = (U16_MAX - sc->prev_timestamp + timestamp + 1);
				else
					delta = timestamp - sc->prev_timestamp;
				sc->timestamp_us += (delta * 16) / 3;
			}
			sc->prev_timestamp = timestamp;
			input_event(sc->sensor_dev, EV_MSC, MSC_TIMESTAMP, sc->timestamp_us);

			offset = data_offset + DS4_INPUT_REPORT_GYRO_X_OFFSET;
			for (n = 0; n < 6; n++) {
				/* Store data in int for more precision during mult_frac. */
				int raw_data = (short)((rd[offset+1] << 8) | rd[offset]);
				struct ds4_calibration_data *calib = &sc->ds4_calib_data[n];

				/* High precision is needed during calibration, but the
				 * calibrated values are within 32-bit.
				 * Note: we swap numerator 'x' and 'numer' in mult_frac for
				 *       precision reasons so we don't need 64-bit.
				 */
				int calib_data = mult_frac(calib->sens_numer,
							   raw_data - calib->bias,
							   calib->sens_denom);

				input_report_abs(sc->sensor_dev, calib->abs_code, calib_data);
				offset += 2;
			}
			input_sync(sc->sensor_dev);

			/*
			 * The lower 4 bits of byte 30 (or 32 for BT) contain the battery level
			 * and the 5th bit contains the USB cable state.
			 */
			offset = data_offset + DS4_INPUT_REPORT_BATTERY_OFFSET;
			cable_state = (rd[offset] >> 4) & 0x01;
			battery_capacity = rd[offset] & 0x0F;

			/*
			 * When a USB power source is connected the battery level ranges from
			 * 0 to 10, and when running on battery power it ranges from 0 to 9.
			 * A battery level above 10 when plugged in means charge completed.
			 */
			if (!cable_state || battery_capacity > 10)
				battery_charging = 0;
			else
				battery_charging = 1;

			if (!cable_state)
				battery_capacity++;
			if (battery_capacity > 10)
				battery_capacity = 10;

			battery_capacity *= 10;

			spin_lock_irqsave(&sc->lock, flags);
			sc->cable_state = cable_state;
			sc->battery_capacity = battery_capacity;
			sc->battery_charging = battery_charging;
			spin_unlock_irqrestore(&sc->lock, flags);

			/*
			 * The Dualshock 4 multi-touch trackpad data starts at offset 33 on USB
			 * and 35 on Bluetooth.
			 * The first byte indicates the number of touch data in the report.
			 * Trackpad data starts 2 bytes later (e.g. 35 for USB).
			 */
			offset = data_offset + DS4_INPUT_REPORT_TOUCHPAD_OFFSET;
			max_touch_data = (sc->quirks & DUALSHOCK4_CONTROLLER_BT) ? 4 : 3;
			if (rd[offset] > 0 && rd[offset] <= max_touch_data)
				num_touch_data = rd[offset];
			else
				num_touch_data = 1;
			offset += 1;

			for (m = 0; m < num_touch_data; m++) {
				/* Skip past timestamp */
				offset += 1;

				/*
				 * The first 7 bits of the first byte is a counter and bit 8 is
				 * a touch indicator that is 0 when pressed and 1 when not
				 * pressed.
				 * The next 3 bytes are two 12 bit touch coordinates, X and Y.
				 * The data for the second touch is in the same format and
				 * immediately follows the data for the first.
				 */
				for (n = 0; n < 2; n++) {
					u16 x, y;
					bool active;

					x = rd[offset+1] | ((rd[offset+2] & 0xF) << 8);
					y = ((rd[offset+2] & 0xF0) >> 4) | (rd[offset+3] << 4);

					active = !(rd[offset] >> 7);
					input_mt_slot(sc->touchpad, n);
					input_mt_report_slot_state(sc->touchpad, MT_TOOL_FINGER, active);

					if (active) {
						input_report_abs(sc->touchpad, ABS_MT_POSITION_X, x);
						input_report_abs(sc->touchpad, ABS_MT_POSITION_Y, y);
					}

					offset += 4;
				}
				input_mt_sync_frame(sc->touchpad);
				input_sync(sc->touchpad);
			}
		}

		static void dualshock4_send_output_report(struct sony_sc *sc)
		{
			struct hid_device *hdev = sc->hdev;
			u8 *buf = sc->output_report_dmabuf;
			int offset;

			/*
			 * NOTE: The lower 6 bits of buf[1] field of the Bluetooth report
			 * control the interval at which Dualshock 4 reports data:
			 * 0x00 - 1ms
			 * 0x01 - 1ms
			 * 0x02 - 2ms
			 * 0x3E - 62ms
			 * 0x3F - disabled
			 */
			if (sc->quirks & (DUALSHOCK4_CONTROLLER_USB | DUALSHOCK4_DONGLE)) {
				memset(buf, 0, DS4_OUTPUT_REPORT_0x05_SIZE);
				buf[0] = 0x05;
				buf[1] = 0x07; /* blink + LEDs + motor */
				offset = 4;
			} else {
				memset(buf, 0, DS4_OUTPUT_REPORT_0x11_SIZE);
				buf[0] = 0x11;
				buf[1] = 0xC0 /* HID + CRC */ | sc->ds4_bt_poll_interval;
				buf[3] = 0x07; /* blink + LEDs + motor */
				offset = 6;
			}

		#ifdef CONFIG_SONY_FF
			buf[offset++] = sc->right;
			buf[offset++] = sc->left;
		#else
			offset += 2;
		#endif

			/* LED 3 is the global control */
			if (sc->led_state[3]) {
				buf[offset++] = sc->led_state[0];
				buf[offset++] = sc->led_state[1];
				buf[offset++] = sc->led_state[2];
			} else {
				offset += 3;
			}

			/* If both delay values are zero the DualShock 4 disables blinking. */
			buf[offset++] = sc->led_delay_on[3];
			buf[offset++] = sc->led_delay_off[3];

			if (sc->quirks & (DUALSHOCK4_CONTROLLER_USB | DUALSHOCK4_DONGLE))
				hid_hw_output_report(hdev, buf, DS4_OUTPUT_REPORT_0x05_SIZE);
			else {
				/* CRC generation */
				u8 bthdr = 0xA2;
				u32 crc;

				crc = crc32_le(0xFFFFFFFF, &bthdr, 1);
				crc = ~crc32_le(crc, buf, DS4_OUTPUT_REPORT_0x11_SIZE-4);
				put_unaligned_le32(crc, &buf[74]);
				hid_hw_output_report(hdev, buf, DS4_OUTPUT_REPORT_0x11_SIZE);
			}
		}

		q
		byte index 	bit 7 	bit 6 	bit 5 	bit 4 	bit 3 	bit 2 	bit 1 	bit 0
		[0] 	Report ID (always 0x01)

		// 6 bytes for gyro, and 6 bytes for accel
		[10] 	Unknown, seems to count downwards, non-random pattern
		[11] 	Unknown, seems to count upwards by 3, but by 2 when [10] underflows

		[10 - 11] 	Seems to be a timestamp.
		A common increment value between two reports is 188 (at full rate the report period is 1.25ms).
		This timestamp is used by the PS4 to process acceleration and gyroscope data.

		[12] 	Unknown yet, 0x03 or 0x04
		*/

		self.gyroX =  Float32(Int16(report[14 + bluetoothOffset] << 8) | Int16(report[13 + bluetoothOffset]))
		self.gyroY =  Float32(Int16(report[16 + bluetoothOffset] << 8) | Int16(report[15 + bluetoothOffset]))
		self.gyroZ =  Float32(Int16(report[18 + bluetoothOffset] << 8) | Int16(report[17 + bluetoothOffset]))

		/*print("gyro z: \(self._gyroZ)")
		print("rotation z: \(self.rotationZ)")*/

		/*
		gyro = new Vector3(
			System.BitConverter.ToInt16(_inputBuffer, 13),
			System.BitConverter.ToInt16(_inputBuffer, 15),
			System.BitConverter.ToInt16(_inputBuffer, 17)
			)/1024f;
		*/

		self.accelX = Float32(Int16(report[22 + bluetoothOffset] << 8) | Int16(report[21 + bluetoothOffset]))
		self.accelY = Float32(Int16(report[20 + bluetoothOffset] << 8) | Int16(report[19 + bluetoothOffset]))
		self.accelZ = Float32(Int16(report[24 + bluetoothOffset] << 8) | Int16(report[23 + bluetoothOffset]))

		/*print("accel x: \(self.accelX)")
		print("accel y: \(self.accelY)")
		print("accel z: \(self.accelZ)") // when rolling, z should be near 0*/


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

		let timestamp = UInt32(report[10 + bluetoothOffset]) | UInt32(report[11 + bluetoothOffset]) << 8
		let timestampUS = (timestamp * 16) / 3

		self.cableConnected = ((report[30 + bluetoothOffset] >> 4) & 0b00000001) == 1
		self.batteryLevel = report[30 + bluetoothOffset] & 0b00001111

		if !self.cableConnected || self.batteryLevel > 10 {
			self.batteryCharging = false
		} else {
			self.batteryCharging = true
		}

		// on usb battery tanges from 0 to 9, but on bluetooth the range is 0 to 10
		if !self.cableConnected && self.batteryLevel < 10  {
			self.batteryLevel += 1
		}

		if self.previousBatteryLevel != self.batteryLevel {

			self.previousBatteryLevel = self.batteryLevel

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: GamePadBatteryChangedNotification.Name,
					object: GamePadBatteryChangedNotification(
						battery: self.batteryLevel,
						batteryMin: 0,
						batteryMax: 8
					)
				)
			}

		}

		/*
		[30] 	EXT/HeadSet/Earset: bitmask

		01111011 is headset with mic (0x7B)
		00111011 is headphones (0x3B)
		00011011 is nothing attached (0x1B)
		00001000 is bluetooth? (0x08)
		00000101 is ? (0x05)
		*/

		//self.sendReport()

	}

	// MARK: - Output reports

	@objc func changeRumble(_ notification:Notification) {

		let o = notification.object as! DualShock4ChangeRumbleNotification

		sendReport(
			leftHeavySlowRumble: o.leftHeavySlowRumble,
			rightLightFastRumble: o.rightLightFastRumble,
			red: 0,
			green: 0,
			blue: 255
		)

	}

	@objc func changeLed(_ notification:Notification) {

		let o = notification.object as! DualShock4ChangeLedNotification

		sendReport(
			leftHeavySlowRumble: 0,
			rightLightFastRumble: 0,
			red: UInt8(o.red * 255),
			green: UInt8(o.green * 255),
			blue: UInt8(o.blue * 255)
		)

	}

	/// How to document parameters?
	/// - Parameter leftHeavySlowRumble: Intensity of the heavy motor
	/// - Parameter rightLightFastRumble: Intensity of the light motor
	/// - Parameter red: Red component of the controller led
	/// - Parameter green: Green component of the controller led
	/// - Parameter blue: Blue component of the controller led
	/// - Parameter flashOn: Duration in a cycle which the led remains on
	/// - Parameter flashOff: Duration in a cycle which the led remains off
	func sendReport(leftHeavySlowRumble:UInt8, rightLightFastRumble:UInt8, red:UInt8, green:UInt8, blue:UInt8, flashOn:UInt8 = 0, flashOff:UInt8 = 0) {

		// let toggleMotor:UInt8 = 0xf0 // 0xf0 disable 0xf3 enable or 0b00001111 // enable unknown, flash, color, rumble

		// let flashOn:UInt8 = 0x00 // flash on duration (in what units??)
		// let flashOff:UInt8 = 0x00 // flash off duration (in what units??)

		let bluetoothOffset = self.isBluetooth ? 2 : 0

		var dualshock4ControllerOutputReport:[UInt8]

		if self.isBluetooth {
			// TODO check this with docs and other projects
			dualshock4ControllerOutputReport = [UInt8](repeating: 0, count: 74)
			dualshock4ControllerOutputReport[0] = 0x15 // 0x11
			dualshock4ControllerOutputReport[1] = 0x0 //(0xC0 | btPollRate) // (0x80 | btPollRate); // input report rate // FIXME check this
			// enable rumble (0x01), lightbar (0x02), flash (0x04) // TODO check this too
			dualshock4ControllerOutputReport[2] = 0xA0
		} else {
			dualshock4ControllerOutputReport = [UInt8](repeating: 0, count: 11)
			dualshock4ControllerOutputReport[0] = 0x05
		}


		// enable rumble (0x01), lightbar (0x02), flash (0x04) 0b00000111
		dualshock4ControllerOutputReport[1 + bluetoothOffset] = 0xf7 // 0b11110111
		dualshock4ControllerOutputReport[2 + bluetoothOffset] = 0x04
		dualshock4ControllerOutputReport[4 + bluetoothOffset] = rightLightFastRumble
		dualshock4ControllerOutputReport[5 + bluetoothOffset] = leftHeavySlowRumble
		dualshock4ControllerOutputReport[6 + bluetoothOffset] = red
		dualshock4ControllerOutputReport[7 + bluetoothOffset] = green
		dualshock4ControllerOutputReport[8 + bluetoothOffset] = blue
		dualshock4ControllerOutputReport[9 + bluetoothOffset] = flashOn
		dualshock4ControllerOutputReport[10 + bluetoothOffset] = flashOff

		if self.isBluetooth {
			// TODO calculate CRC32 here
			/*let dualshock4ControllerInputReportBluetoothCRC = CRC32.checksum(bytes: dualshock4ControllerInputReportBluetooth)
			dualshock4ControllerInputReportBluetooth.append(contentsOf: dualshock4ControllerInputReportBluetoothCRC)*/
		}

		print("size of report: \(dualshock4ControllerOutputReport.count)")

		IOHIDDeviceSetReport(
			device,
			kIOHIDReportTypeOutput,
			0x01, // report id
			dualshock4ControllerOutputReport,
			dualshock4ControllerOutputReport.count
		)

	}

	// MARK: - Gryroscope calibration

	static let ACC_RES_PER_G:Int16 = 8192; // TODO means 1G is 8192 (1 and a half byte) 0b0000_0000_0000 ??

	static let GYRO_RES_IN_DEG_SEC:Int16 = 16; // means 1 degree/second is 16 (4 bits) 0b0000 ??

	func requestCalibrationDataReport() {

		/*
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
		*/

		var dualshock4CalibrationDataReport = [UInt8](repeating: 0, count: 41)
		let dualshock4CalibrationDataReportLength = dualshock4CalibrationDataReport.count

		let dualshock4CalibrationDataReportPointer = UnsafeMutablePointer(mutating: dualshock4CalibrationDataReport)
		let dualshock4CalibrationDataReportLengthPointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
		dualshock4CalibrationDataReportLengthPointer.pointee = dualshock4CalibrationDataReportLength

		IOHIDDeviceGetReport(
			device,
			kIOHIDReportTypeFeature,
			self.isBluetooth ? 0x05 : 0x02, // TODO test bluetooth
			dualshock4CalibrationDataReportPointer,
			dualshock4CalibrationDataReportLengthPointer
		)

		// TODO validar CRC aqui

		self.parseCalibrationFeatureReport(calibrationReport: &dualshock4CalibrationDataReport, fromUSB: self.isBluetooth)

		/*
		// for reference:
		[0] 5 // report type
		[1] 251
		[2] 255
		[3] 252
		[4] 255
		[5] 255
		[6] 255
		[7] 157
		[8] 33
		[9] 165
		[10] 34
		[11] 102
		[12] 36
		[13] 94
		[14] 222
		[15] 91
		[16] 221
		[17] 143
		[18] 219
		[19] 28
		[20] 2
		[21] 28
		[22] 2
		[23] 87
		[24] 31
		[25] 169
		[26] 224
		[27] 218
		[28] 32
		[29] 38
		[30] 223
		[31] 207
		[32] 31
		[33] 49
		[34] 224
		[35] 6
		[36] 0
		[37] 212 crc32
		[38] 77  crc32
		[39] 82  crc32
		[40] 113 crc32
		*/

		print("resultado")
		print(dualshock4CalibrationDataReportLength)
		print(dualshock4CalibrationDataReport)

	}

	func parseCalibrationFeatureReport(calibrationReport:inout [UInt8], fromUSB:Bool) {

		// gyroscopes

		var pitchPlus:Int16 = 0;
		var pitchMinus:Int16 = 0;
		var yawPlus:Int16 = 0;
		var yawMinus:Int16 = 0;
		var rollPlus:Int16 = 0;
		var rollMinus:Int16 = 0;

		if !fromUSB {

			pitchPlus  = Int16(calibrationReport[8]  << 8) | Int16(calibrationReport[7]);
			yawPlus    = Int16(calibrationReport[10] << 8) | Int16(calibrationReport[9]);
			rollPlus   = Int16(calibrationReport[12] << 8) | Int16(calibrationReport[11]);
			pitchMinus = Int16(calibrationReport[14] << 8) | Int16(calibrationReport[13]);
			yawMinus   = Int16(calibrationReport[16] << 8) | Int16(calibrationReport[15]);
			rollMinus  = Int16(calibrationReport[18] << 8) | Int16(calibrationReport[17]);

		} else {

			pitchPlus  = Int16(calibrationReport[8]  << 8) | Int16(calibrationReport[7]);
			pitchMinus = Int16(calibrationReport[10] << 8) | Int16(calibrationReport[9]);
			yawPlus    = Int16(calibrationReport[12] << 8) | Int16(calibrationReport[11]);
			yawMinus   = Int16(calibrationReport[14] << 8) | Int16(calibrationReport[13]);
			rollPlus   = Int16(calibrationReport[16] << 8) | Int16(calibrationReport[15]);
			rollMinus  = Int16(calibrationReport[18] << 8) | Int16(calibrationReport[17]);

		}

		self.calibration[Calibration.GyroPitchIndex].plusValue = pitchPlus;
		self.calibration[Calibration.GyroPitchIndex].minusValue = pitchMinus;

		self.calibration[Calibration.GyroYawIndex].plusValue = yawPlus;
		self.calibration[Calibration.GyroYawIndex].minusValue = yawMinus;

		self.calibration[Calibration.GyroRollIndex].plusValue = rollPlus;
		self.calibration[Calibration.GyroRollIndex].minusValue = rollMinus;

		self.calibration[Calibration.GyroPitchIndex].sensorBias = Int16(calibrationReport[2] << 8) | Int16(calibrationReport[1]);
		self.calibration[Calibration.GyroYawIndex].sensorBias   = Int16(calibrationReport[4] << 8) | Int16(calibrationReport[3]);
		self.calibration[Calibration.GyroRollIndex].sensorBias  = Int16(calibrationReport[6] << 8) | Int16(calibrationReport[5]);

		self.gyroSpeedPlus  = Int16(calibrationReport[20] << 8) | Int16(calibrationReport[19]);
		self.gyroSpeedMinus = Int16(calibrationReport[22] << 8) | Int16(calibrationReport[21]);
		self.gyroSpeed2x = (Int16)(gyroSpeedPlus + gyroSpeedMinus);

		// accelerometers

		let accelXPlus  = Int16(calibrationReport[24] << 8) | Int16(calibrationReport[23]);
		let accelXMinus = Int16(calibrationReport[26] << 8) | Int16(calibrationReport[25]);

		let accelYPlus  = Int16(calibrationReport[28] << 8) | Int16(calibrationReport[27]);
		let accelYMinus = Int16(calibrationReport[30] << 8) | Int16(calibrationReport[29]);

		let accelZPlus  = Int16(calibrationReport[32] << 8) | Int16(calibrationReport[31]);
		let accelZMinus = Int16(calibrationReport[34] << 8) | Int16(calibrationReport[33]);

		self.calibration[Calibration.AccelXIndex].plusValue   = accelXPlus;
		self.calibration[Calibration.AccelXIndex].minusValue  = accelXMinus;

		self.calibration[Calibration.AccelYIndex].plusValue   = accelYPlus;
		self.calibration[Calibration.AccelYIndex].minusValue  = accelYMinus;

		self.calibration[Calibration.AccelZIndex].plusValue   = accelZPlus;
		self.calibration[Calibration.AccelZIndex].minusValue  = accelZMinus;

		self.calibration[Calibration.AccelXIndex].sensorBias = (Int16)(accelXPlus - ((accelXPlus - accelXMinus) / 2));
		self.calibration[Calibration.AccelYIndex].sensorBias = (Int16)(accelYPlus - ((accelYPlus - accelYMinus) / 2));
		self.calibration[Calibration.AccelZIndex].sensorBias = (Int16)(accelZPlus - ((accelZPlus - accelZMinus) / 2));

	}

	func applyCalibration(
		pitch:inout Int16, yaw:inout Int16, roll:inout Int16,
		accelX:inout Int16, accelY:inout Int16, accelZ:inout Int16
	) {

		pitch = DualShock4Controller.applyGyroCalibration(
			pitch,
			self.calibration[Calibration.GyroPitchIndex].sensorBias!,
			self.gyroSpeed2x,
			sensorResolution: DualShock4Controller.GYRO_RES_IN_DEG_SEC,
			sensorRange: Int16(self.calibration[Calibration.GyroPitchIndex].plusValue! - self.calibration[Calibration.GyroPitchIndex].minusValue!)
		);

		yaw = DualShock4Controller.applyGyroCalibration(
			yaw,
			self.calibration[Calibration.GyroYawIndex].sensorBias!,
			self.gyroSpeed2x,
			sensorResolution: DualShock4Controller.GYRO_RES_IN_DEG_SEC,
			sensorRange: Int16(self.calibration[Calibration.GyroYawIndex].plusValue! - self.calibration[Calibration.GyroYawIndex].minusValue!)
		);

		roll = DualShock4Controller.applyGyroCalibration(
			roll,
			self.calibration[Calibration.GyroRollIndex].sensorBias!,
			self.gyroSpeed2x,
			sensorResolution: DualShock4Controller.GYRO_RES_IN_DEG_SEC,
			sensorRange: Int16(self.calibration[Calibration.GyroRollIndex].plusValue! - self.calibration[Calibration.GyroRollIndex].minusValue!)
		);

		accelX = DualShock4Controller.applyAccelCalibration(
			accelX,
			self.calibration[Calibration.AccelXIndex].sensorBias!,
			sensorResolution: DualShock4Controller.ACC_RES_PER_G,
			sensorRange: Int16(self.calibration[Calibration.AccelXIndex].plusValue! - self.calibration[Calibration.AccelXIndex].minusValue!)
		);

		accelY = DualShock4Controller.applyAccelCalibration(
			accelY,
			self.calibration[Calibration.AccelYIndex].sensorBias!,
			sensorResolution: DualShock4Controller.ACC_RES_PER_G,
			sensorRange: Int16(self.calibration[Calibration.AccelYIndex].plusValue! - self.calibration[Calibration.AccelYIndex].minusValue!)
		);

		accelZ = DualShock4Controller.applyAccelCalibration(
			accelZ,
			self.calibration[Calibration.AccelZIndex].sensorBias!,
			sensorResolution: DualShock4Controller.ACC_RES_PER_G,
			sensorRange: Int16(self.calibration[Calibration.AccelZIndex].plusValue! - self.calibration[Calibration.AccelZIndex].minusValue!)
		);

	}

	static func applyGyroCalibration(_ sensorRawValue:Int16, _ sensorBias:Int16, _ gyroSpeed2x:Int16, sensorResolution:Int16, sensorRange:Int16) -> Int16 {
		var calibratedValue:Int16 = 0; // TODO not sure why I would need this to be an integer

		// plus and minus values are symmetrical, so bias is also 0
		if sensorRange == 0 {
			calibratedValue = (Int16)(sensorRawValue * gyroSpeed2x * sensorResolution);
			return calibratedValue;
		}

		calibratedValue = Int16(((sensorRawValue - sensorBias) * gyroSpeed2x * sensorResolution) / sensorRange);
		return calibratedValue;
	}

	static func applyAccelCalibration(_ sensorRawValue:Int16, _ sensorBias:Int16, sensorResolution:Int16, sensorRange:Int16) -> Int16 {
		var calibratedValue:Int16 = 0; // TODO not sure why I would need this to be an integer

		// plus and minus values are symmetrical, so bias is also 0
		if sensorRange == 0 {
			calibratedValue = Int16(sensorRawValue * 2 * sensorResolution);
			return calibratedValue;
		}

		calibratedValue = Int16(((sensorRawValue - sensorBias) * 2 * sensorResolution) / sensorRange);
		return calibratedValue;
	}

	var gyroSpeedPlus:Int16 = 0;
	var gyroSpeedMinus:Int16 = 0;
	var gyroSpeed2x:Int16 = 0;

	// TODO change this to a struct or object with properties, array with indexes is kind of ugly
	var calibration = [
		Calibration(),
		Calibration(),
		Calibration(),
		Calibration(),
		Calibration(),
		Calibration()
	];

}

class Calibration {

	static let GyroPitchIndex:Int = 0;
	static let GyroYawIndex:Int = 1;
	static let GyroRollIndex:Int = 2;
	static let AccelXIndex:Int = 3;
	static let AccelYIndex:Int = 4;
	static let AccelZIndex:Int = 5;

	public init() {
		//
	}

	var plusValue:Int16?;
	var minusValue:Int16?;
	var sensorBias:Int16?;

}
