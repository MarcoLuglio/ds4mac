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
	/// digital reading for left trigger
	/// for the analog reading see leftTrigger
	var l2:Bool = false
	var previousL2:Bool = false
	/// digital reading for right trigger
	/// for the analog reading see rightTrigger
	var r2:Bool = false
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

	var gyroX:Float32 = 0
	var gyroY:Float32 = 0
	var _gyroZ:Float32 = 0

	var accelX:Float32 = 0
	var accelY:Float32 = 0
	var accelZ:Float32 = 0

	var rotationZ:Float32 = 0

	// battery

	var cableConnected: Bool = false
	var batteryCharging:Bool = false
	var batteryLevel:UInt8 = 0 // 0 to 9 on USB, 0 - 10 on Bluetooth
	var previousBatteryLevel:UInt8 = 0

	// misc

	var reportIterator:UInt8 = 0
	var previousReportIterator:UInt8 = 0

	init(_ device:IOHIDDevice, productID:Int64, transport:String, enableIMUReport:Bool) {

		self.id = DualShock4Controller.nextId
		DualShock4Controller.nextId = DualShock4Controller.nextId + 1

		self.productID = productID
		self.transport = transport
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

	}

	public private(set) var gyroZ:Float32 {

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

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data) {

		self.previousTime = self.time
		self.time = Date()
		self.timeInterval = self.time.timeIntervalSince(self.previousTime) * 1_000_000

		self.mainButtons = report[5]

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

		self.reportIterator = report[7] >> 2 // [7] 	Counter (counts up by 1 per report), I guess this is only relevant to bluetooth

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
		self.leftStickX = report[1] // 0 left
		self.leftStickY = report[2] // 0 up
		self.rightStickX = report[3]
		self.rightStickY = report[4]
		self.leftTrigger = report[8] // 0 - 255
		self.rightTrigger = report[9] // 0 - 255

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

		if report.count < 11 {
			self.isBluetooth = true // TODO find the correct way to check if it is bluetooth or not

			// TODO enable gyro

			return
		}

		self.previousReportTime = self.reportTime
		self.reportTime = (Int32(report[11]) << 8 | Int32(report[10])) // this is little endian
		self.reportTimeInterval = self.reportTime - self.previousReportTime
		if self.reportTimeInterval < 0 {
			self.reportTimeInterval += UINT16_MAX
		}

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
			struct hid_input *hidinput = list_entry(sc->hdev->inputs.next,
								struct hid_input, list);
			struct input_dev *input_dev = hidinput->input;
			unsigned long flags;
			int n, m, offset, num_touch_data, max_touch_data;
			u8 cable_state, battery_capacity, battery_charging;
			u16 timestamp;

			/* When using Bluetooth the header is 2 bytes longer, so skip these. */
			int data_offset = (sc->quirks & DUALSHOCK4_CONTROLLER_BT) ? 2 : 0;

			/* Second bit of third button byte is for the touchpad button. */
			offset = data_offset + DS4_INPUT_REPORT_BUTTON_OFFSET;
			input_report_key(sc->touchpad, BTN_LEFT, rd[offset+2] & 0x2);

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
			if (rd[0] == 17) {
				int value;

				offset = data_offset + DS4_INPUT_REPORT_AXIS_OFFSET;
				input_report_abs(input_dev, ABS_X, rd[offset]);
				input_report_abs(input_dev, ABS_Y, rd[offset+1]);
				input_report_abs(input_dev, ABS_RX, rd[offset+2]);
				input_report_abs(input_dev, ABS_RY, rd[offset+3]);

				value = rd[offset+4] & 0xf;
				if (value > 7)
					value = 8; /* Center 0, 0 */
				input_report_abs(input_dev, ABS_HAT0X, ds4_hat_mapping[value].x);
				input_report_abs(input_dev, ABS_HAT0Y, ds4_hat_mapping[value].y);

				input_report_key(input_dev, BTN_WEST, rd[offset+4] & 0x10);
				input_report_key(input_dev, BTN_SOUTH, rd[offset+4] & 0x20);
				input_report_key(input_dev, BTN_EAST, rd[offset+4] & 0x40);
				input_report_key(input_dev, BTN_NORTH, rd[offset+4] & 0x80);

				input_report_key(input_dev, BTN_TL, rd[offset+5] & 0x1);
				input_report_key(input_dev, BTN_TR, rd[offset+5] & 0x2);
				input_report_key(input_dev, BTN_TL2, rd[offset+5] & 0x4);
				input_report_key(input_dev, BTN_TR2, rd[offset+5] & 0x8);
				input_report_key(input_dev, BTN_SELECT, rd[offset+5] & 0x10);
				input_report_key(input_dev, BTN_START, rd[offset+5] & 0x20);
				input_report_key(input_dev, BTN_THUMBL, rd[offset+5] & 0x40);
				input_report_key(input_dev, BTN_THUMBR, rd[offset+5] & 0x80);

				input_report_key(input_dev, BTN_MODE, rd[offset+6] & 0x1);

				input_report_abs(input_dev, ABS_Z, rd[offset+7]);
				input_report_abs(input_dev, ABS_RZ, rd[offset+8]);

				input_sync(input_dev);
			}

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

		/*
		 * Request DS4 calibration data for the motion sensors.
		 * For Bluetooth this also affects the operating mode (see below).
		 */
		static int dualshock4_get_calibration_data(struct sony_sc *sc)
		{
			u8 *buf;
			int ret;
			short gyro_pitch_bias, gyro_pitch_plus, gyro_pitch_minus;
			short gyro_yaw_bias, gyro_yaw_plus, gyro_yaw_minus;
			short gyro_roll_bias, gyro_roll_plus, gyro_roll_minus;
			short gyro_speed_plus, gyro_speed_minus;
			short acc_x_plus, acc_x_minus;
			short acc_y_plus, acc_y_minus;
			short acc_z_plus, acc_z_minus;
			int speed_2x;
			int range_2g;

			/* For Bluetooth we use a different request, which supports CRC.
			 * Note: in Bluetooth mode feature report 0x02 also changes the state
			 * of the controller, so that it sends input reports of type 0x11.
			 */
			if (sc->quirks & (DUALSHOCK4_CONTROLLER_USB | DUALSHOCK4_DONGLE)) {
				buf = kmalloc(DS4_FEATURE_REPORT_0x02_SIZE, GFP_KERNEL);
				if (!buf)
					return -ENOMEM;

				ret = hid_hw_raw_request(sc->hdev, 0x02, buf,
							 DS4_FEATURE_REPORT_0x02_SIZE,
							 HID_FEATURE_REPORT,
							 HID_REQ_GET_REPORT);
				if (ret < 0)
					goto err_stop;
			} else {
				u8 bthdr = 0xA3;
				u32 crc;
				u32 report_crc;
				int retries;

				buf = kmalloc(DS4_FEATURE_REPORT_0x05_SIZE, GFP_KERNEL);
				if (!buf)
					return -ENOMEM;

				for (retries = 0; retries < 3; retries++) {
					ret = hid_hw_raw_request(sc->hdev, 0x05, buf,
								 DS4_FEATURE_REPORT_0x05_SIZE,
								 HID_FEATURE_REPORT,
								 HID_REQ_GET_REPORT);
					if (ret < 0)
						goto err_stop;

					/* CRC check */
					crc = crc32_le(0xFFFFFFFF, &bthdr, 1);
					crc = ~crc32_le(crc, buf, DS4_FEATURE_REPORT_0x05_SIZE-4);
					report_crc = get_unaligned_le32(&buf[DS4_FEATURE_REPORT_0x05_SIZE-4]);
					if (crc != report_crc) {
						hid_warn(sc->hdev, "DualShock 4 calibration report's CRC check failed, received crc 0x%0x != 0x%0x\n",
							report_crc, crc);
						if (retries < 2) {
							hid_warn(sc->hdev, "Retrying DualShock 4 get calibration report request\n");
							continue;
						} else {
							ret = -EILSEQ;
							goto err_stop;
						}
					} else {
						break;
					}
				}
			}

			gyro_pitch_bias  = get_unaligned_le16(&buf[1]);
			gyro_yaw_bias    = get_unaligned_le16(&buf[3]);
			gyro_roll_bias   = get_unaligned_le16(&buf[5]);
			if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
				gyro_pitch_plus  = get_unaligned_le16(&buf[7]);
				gyro_pitch_minus = get_unaligned_le16(&buf[9]);
				gyro_yaw_plus    = get_unaligned_le16(&buf[11]);
				gyro_yaw_minus   = get_unaligned_le16(&buf[13]);
				gyro_roll_plus   = get_unaligned_le16(&buf[15]);
				gyro_roll_minus  = get_unaligned_le16(&buf[17]);
			} else {
				/* BT + Dongle */
				gyro_pitch_plus  = get_unaligned_le16(&buf[7]);
				gyro_yaw_plus    = get_unaligned_le16(&buf[9]);
				gyro_roll_plus   = get_unaligned_le16(&buf[11]);
				gyro_pitch_minus = get_unaligned_le16(&buf[13]);
				gyro_yaw_minus   = get_unaligned_le16(&buf[15]);
				gyro_roll_minus  = get_unaligned_le16(&buf[17]);
			}
			gyro_speed_plus  = get_unaligned_le16(&buf[19]);
			gyro_speed_minus = get_unaligned_le16(&buf[21]);
			acc_x_plus       = get_unaligned_le16(&buf[23]);
			acc_x_minus      = get_unaligned_le16(&buf[25]);
			acc_y_plus       = get_unaligned_le16(&buf[27]);
			acc_y_minus      = get_unaligned_le16(&buf[29]);
			acc_z_plus       = get_unaligned_le16(&buf[31]);
			acc_z_minus      = get_unaligned_le16(&buf[33]);

			/* Set gyroscope calibration and normalization parameters.
			 * Data values will be normalized to 1/DS4_GYRO_RES_PER_DEG_S degree/s.
			 */
			speed_2x = (gyro_speed_plus + gyro_speed_minus);
			sc->ds4_calib_data[0].abs_code = ABS_RX;
			sc->ds4_calib_data[0].bias = gyro_pitch_bias;
			sc->ds4_calib_data[0].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
			sc->ds4_calib_data[0].sens_denom = gyro_pitch_plus - gyro_pitch_minus;

			sc->ds4_calib_data[1].abs_code = ABS_RY;
			sc->ds4_calib_data[1].bias = gyro_yaw_bias;
			sc->ds4_calib_data[1].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
			sc->ds4_calib_data[1].sens_denom = gyro_yaw_plus - gyro_yaw_minus;

			sc->ds4_calib_data[2].abs_code = ABS_RZ;
			sc->ds4_calib_data[2].bias = gyro_roll_bias;
			sc->ds4_calib_data[2].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
			sc->ds4_calib_data[2].sens_denom = gyro_roll_plus - gyro_roll_minus;

			/* Set accelerometer calibration and normalization parameters.
			 * Data values will be normalized to 1/DS4_ACC_RES_PER_G G.
			 */
			range_2g = acc_x_plus - acc_x_minus;
			sc->ds4_calib_data[3].abs_code = ABS_X;
			sc->ds4_calib_data[3].bias = acc_x_plus - range_2g / 2;
			sc->ds4_calib_data[3].sens_numer = 2*DS4_ACC_RES_PER_G;
			sc->ds4_calib_data[3].sens_denom = range_2g;

			range_2g = acc_y_plus - acc_y_minus;
			sc->ds4_calib_data[4].abs_code = ABS_Y;
			sc->ds4_calib_data[4].bias = acc_y_plus - range_2g / 2;
			sc->ds4_calib_data[4].sens_numer = 2*DS4_ACC_RES_PER_G;
			sc->ds4_calib_data[4].sens_denom = range_2g;

			range_2g = acc_z_plus - acc_z_minus;
			sc->ds4_calib_data[5].abs_code = ABS_Z;
			sc->ds4_calib_data[5].bias = acc_z_plus - range_2g / 2;
			sc->ds4_calib_data[5].sens_numer = 2*DS4_ACC_RES_PER_G;
			sc->ds4_calib_data[5].sens_denom = range_2g;

		err_stop:
			kfree(buf);
			return ret;
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

		self.gyroX =  Float32(Int16(report[14] << 8) | Int16(report[13]))
		self.gyroY =  Float32(Int16(report[16] << 8) | Int16(report[15]))
		self.gyroZ =  Float32(Int16(report[18] << 8) | Int16(report[17]))

		/*print("gyro z: \(self._gyroZ)")
		print("rotation z: \(self.rotationZ)")*/

		/*
		gyro = new Vector3(
			System.BitConverter.ToInt16(_inputBuffer, 13),
			System.BitConverter.ToInt16(_inputBuffer, 15),
			System.BitConverter.ToInt16(_inputBuffer, 17)
			)/1024f;
		*/

		self.accelX = Float32(Int16(report[22] << 8) | Int16(report[21]))
		self.accelY = Float32(Int16(report[20] << 8) | Int16(report[19]))
		self.accelZ = Float32(Int16(report[24] << 8) | Int16(report[23]))

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

		let timestamp = UInt32(report[10]) | UInt32(report[11]) << 8
		let timestampUS = (timestamp * 16) / 3

		self.cableConnected = ((report[30] >> 4) & 0b00000001) == 1
		self.batteryLevel = report[30] & 0b00001111

		if !cableConnected || self.batteryLevel > 10 {
			self.batteryCharging = false
		} else {
			self.batteryCharging = true
		}

		if !cableConnected && self.batteryLevel < 10  {
			self.batteryLevel += 1
		}

		if self.previousBatteryLevel != self.batteryLevel { // TODO there are differences when measuring over bluetooth

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

		var dualshock4CalibrationDataReportBluetooth = [UInt8](repeating: 0, count: 41)
		var dualshock4CalibrationDataReportBluetoothLength = dualshock4CalibrationDataReportBluetooth.count

		var dualshock4CalibrationDataReportBluetoothPointer = unsafeBitCast(dualshock4CalibrationDataReportBluetooth, to: UnsafeMutablePointer<UInt8>.self)
		var dualshock4CalibrationDataReportBluetoothLengthPointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
		dualshock4CalibrationDataReportBluetoothLengthPointer.pointee = dualshock4CalibrationDataReportBluetoothLength

		IOHIDDeviceGetReport(
			device,
			kIOHIDReportTypeFeature,
			0x05, // report id / protocol code
			dualshock4CalibrationDataReportBluetoothPointer,
			dualshock4CalibrationDataReportBluetoothLengthPointer
		)

		print("resultado")
		print(dualshock4CalibrationDataReportBluetoothLength)
		//print(dualshock4CalibrationDataReportBluetooth)

		// TODO validar CRC aqui

		/*var dualshock4CalibrationDataReportUSB = [UInt8](repeating: 0, count: 37)
		var dualshock4CalibrationDataReportUSBLength = dualshock4CalibrationDataReportUSB.count

		var dualshock4CalibrationDataReportUSBPointer = unsafeBitCast(dualshock4CalibrationDataReportUSB, to: UnsafeMutablePointer<UInt8>.self)
		var dualshock4CalibrationDataReportUSBLengthPointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
		dualshock4CalibrationDataReportUSBLengthPointer.pointee = dualshock4CalibrationDataReportUSBLength

		print("resultado")
		print(dualshock4CalibrationDataReportUSB)

		IOHIDDeviceGetReport(
			device,
			kIOHIDReportTypeFeature,
			0x02, // report id / protocol code
			dualshock4CalibrationDataReportUSBPointer,
			dualshock4CalibrationDataReportUSBLengthPointer
		)*/

		/*
		static inline u16 get_unaligned_le16(const void *p)
		{
			const u8 *_p = p;
			return _p[0] | _p[1] << 8;
		}

		gyro_pitch_bias  = get_unaligned_le16(&buf[1]);
		gyro_yaw_bias    = get_unaligned_le16(&buf[3]);
		gyro_roll_bias   = get_unaligned_le16(&buf[5]);
		if (sc->quirks & DUALSHOCK4_CONTROLLER_USB) {
			gyro_pitch_plus  = get_unaligned_le16(&buf[7]);
			gyro_pitch_minus = get_unaligned_le16(&buf[9]);
			gyro_yaw_plus    = get_unaligned_le16(&buf[11]);
			gyro_yaw_minus   = get_unaligned_le16(&buf[13]);
			gyro_roll_plus   = get_unaligned_le16(&buf[15]);
			gyro_roll_minus  = get_unaligned_le16(&buf[17]);
		} else {
			/* BT + Dongle */
			gyro_pitch_plus  = get_unaligned_le16(&buf[7]);
			gyro_yaw_plus    = get_unaligned_le16(&buf[9]);
			gyro_roll_plus   = get_unaligned_le16(&buf[11]);
			gyro_pitch_minus = get_unaligned_le16(&buf[13]);
			gyro_yaw_minus   = get_unaligned_le16(&buf[15]);
			gyro_roll_minus  = get_unaligned_le16(&buf[17]);
		}
		gyro_speed_plus  = get_unaligned_le16(&buf[19]);
		gyro_speed_minus = get_unaligned_le16(&buf[21]);
		acc_x_plus       = get_unaligned_le16(&buf[23]);
		acc_x_minus      = get_unaligned_le16(&buf[25]);
		acc_y_plus       = get_unaligned_le16(&buf[27]);
		acc_y_minus      = get_unaligned_le16(&buf[29]);
		acc_z_plus       = get_unaligned_le16(&buf[31]);
		acc_z_minus      = get_unaligned_le16(&buf[33]);

		/* Set gyroscope calibration and normalization parameters.
		 * Data values will be normalized to 1/DS4_GYRO_RES_PER_DEG_S degree/s.
		 */
		speed_2x = (gyro_speed_plus + gyro_speed_minus);
		sc->ds4_calib_data[0].abs_code = ABS_RX;
		sc->ds4_calib_data[0].bias = gyro_pitch_bias;
		sc->ds4_calib_data[0].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
		sc->ds4_calib_data[0].sens_denom = gyro_pitch_plus - gyro_pitch_minus;

		sc->ds4_calib_data[1].abs_code = ABS_RY;
		sc->ds4_calib_data[1].bias = gyro_yaw_bias;
		sc->ds4_calib_data[1].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
		sc->ds4_calib_data[1].sens_denom = gyro_yaw_plus - gyro_yaw_minus;

		sc->ds4_calib_data[2].abs_code = ABS_RZ;
		sc->ds4_calib_data[2].bias = gyro_roll_bias;
		sc->ds4_calib_data[2].sens_numer = speed_2x*DS4_GYRO_RES_PER_DEG_S;
		sc->ds4_calib_data[2].sens_denom = gyro_roll_plus - gyro_roll_minus;

		/* Set accelerometer calibration and normalization parameters.
		 * Data values will be normalized to 1/DS4_ACC_RES_PER_G G.
		 */
		range_2g = acc_x_plus - acc_x_minus;
		sc->ds4_calib_data[3].abs_code = ABS_X;
		sc->ds4_calib_data[3].bias = acc_x_plus - range_2g / 2;
		sc->ds4_calib_data[3].sens_numer = 2*DS4_ACC_RES_PER_G;
		sc->ds4_calib_data[3].sens_denom = range_2g;

		range_2g = acc_y_plus - acc_y_minus;
		sc->ds4_calib_data[4].abs_code = ABS_Y;
		sc->ds4_calib_data[4].bias = acc_y_plus - range_2g / 2;
		sc->ds4_calib_data[4].sens_numer = 2*DS4_ACC_RES_PER_G;
		sc->ds4_calib_data[4].sens_denom = range_2g;

		range_2g = acc_z_plus - acc_z_minus;
		sc->ds4_calib_data[5].abs_code = ABS_Z;
		sc->ds4_calib_data[5].bias = acc_z_plus - range_2g / 2;
		sc->ds4_calib_data[5].sens_numer = 2*DS4_ACC_RES_PER_G;
		sc->ds4_calib_data[5].sens_denom = range_2g;
		*/

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

		//let toggleMotor:UInt8 = 0xf0 // 0xf0 disable 0xf3 enable or 0b00001111 // enable unknown, flash, color, rumble

		//let flashOn:UInt8 = 0x00 // flash on duration (in what units??)
		//let flashOff:UInt8 = 0x00 // flash off duration (in what units??)

		let bluetoothOffset = 2

		var dualshock4ControllerInputReportUSB = [UInt8](repeating: 0, count: 11) // 31 over bluetooth

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
			0x01, // report id
			dualshock4ControllerInputReportUSB,
			dualshock4ControllerInputReportUSB.count
		)

	}

}
