//
//  JoyConController.swift
//  GamePad
//
//  Created by Marco Luglio on 06/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class JoyConController {

	static let VENDOR_ID_NINTENDO:Int64 = 0x057E // 1406
	static let CONTROLLER_ID_JOY_CON_LEFT:Int64 = 0x2006 // 8198
	static let CONTROLLER_ID_JOY_CON_RIGHT:Int64 = 0x2007 // 8199
	static let CONTROLLER_ID_SWITCH_PRO:Int64 = 0x2009 // 8201
	static let CONTROLLER_ID_CHARGING_GRIP:Int64 = 0x200e // 8206
	// 0x0306 Wii Remote Controller RVL-003
	// 0x0337 Wii U GameCube Controller Adapter

	static let INPUT_REPORT_ID_BUTTONS:UInt8 = 0x3F // Simple HID mode. Pushes updates with every button press. Thumbstick is 8 directions only
	static let INPUT_REPORT_ID_BUTTONS_GYRO:UInt8 = 0x30 // Standard full mode. Pushes current state @60Hz
	static let INPUT_REPORT_ID_BUTTONS_GYRO_NFC_IR:UInt8 = 0x31 // near field communication reader and infra red camera mode. Pushes large packets @60Hz. Has all zeroes for IR/NFC data if a 11 output report with subcmd 03 00/01/02/03 was not sent before.

	static let OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE:UInt8 = 0x01
	static let OUTPUT_REPORT_ID_RUMBLE:UInt8 = 0x10
	static let OUTPUT_REPORT_ID_NFC_IR:UInt8 = 0x11 // Request specific data from the NFC/IR MCU. Can also send rumble. Send with subcmd 03 00/01/02/03??

	static let OUTPUT_REPORT_SUB_ID_SET_INPUT_REPORT_ID:UInt8 = 0x03
	static let OUTPUT_REPORT_SUB_ID_SET_PLAYER_LIGHTS:UInt8   = 0x30
	static let OUTPUT_REPORT_SUB_ID_GET_PLAYER_LIGHTS:UInt8   = 0x31
	static let OUTPUT_REPORT_SUB_ID_SET_HOME_LIGHT:UInt8      = 0x38
	static let OUTPUT_REPORT_SUB_ID_TOGGLE_IMU:UInt8          = 0x40
	static let OUTPUT_REPORT_SUB_ID_IMU_SETTINGS:UInt8        = 0x41
	static let OUTPUT_REPORT_SUB_ID_TOGGLE_VIBRATION:UInt8    = 0x48
	static let OUTPUT_REPORT_SUB_ID_BATTERY_VOLTAGE:UInt8     = 0x50

	/*
	Subcommand 0x22: Set NFC/IR MCU state

	Takes one argument:
	Argument # 	Remarks
	00 	Suspend
	01 	Resume
	02 	Resume for update



	OUTPUT 0x03
	NFC/IR MCU FW Update packet.
	*/

	static let MAX_STICK = 4096 // 2 ^ 12

	static var outputReportIterator:UInt8 = 0

	static var nextId:UInt8 = 0

	var id:UInt8 = 0

	var productID:Int64 = 0
	var transport:String = ""

	var isBluetooth = false

	// MARK: - left joy-con

	var leftDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var leftMainButtons:UInt8 = 0
	var previousLeftMainButtons:UInt8 = 0

	var directionalPad:UInt8 = 0
	var previousDirectionalPad:UInt8 = 0

	var upButton = false
	var previousUpButton = false
	var rightButton = false
	var previousRightButton = false
	var downButton = false
	var previousDownButton = false
	var leftButton = false
	var previousLeftButton = false

	// TODO The S* buttons can be the equivalent of the Xbox Elite back paddles

	/// SL button on left joy-con
	var leftSideTopButton = false
	var previousLeftSideTopButton = false

	/// SR on left joy-con
	var leftSideBottomButton = false
	var previousLeftSideBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var leftSecondaryButtons:UInt8 = 0
	var previousLeftSecondaryButtons:UInt8 = 0

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

	// analog buttons (thumbstick only for joy-cons)
	// notice that the simpified report only gives us 8 directions, not analog data

	var leftStickButton = false
	var previousLeftStickButton = false

	// 8 direction stick data
	var leftStick:UInt8 = 0
	var previousLeftStick:UInt8 = 0

	// analog stick data
	var leftStickX:Int16 = 0
	var previousLeftStickX:Int16 = 0
	var leftStickY:Int16 = 0
	var previousLeftStickY:Int16 = 0

	// inertial measurement unit (imu)

	var leftGyroPitch:Int32 = 0
	var leftPreviousGyroPitch:Int32 = 0
	var leftGyroYaw:Int32 = 0
	var leftPreviousGyroYaw:Int32 = 0
	var leftGyroRoll:Int32 = 0
	var leftPreviousGyroRoll:Int32 = 0

	var leftAccelX:Int32 = 0
	var leftPreviousAccelX:Int32 = 0
	var leftAccelY:Int32 = 0
	var leftPreviousAccelY:Int32 = 0
	var leftAccelZ:Int32 = 0
	var leftPreviousAccelZ:Int32 = 0

	// battery
	//var cableConnected = false
	var batteryLeftCharging = false
	var batteryLeftLevel:UInt8 = 0
	var previousBatteryLeftLevel:UInt8 = 0

	// misc

	// MARK: - right joy-con

	var rightDevice:IOHIDDevice? = nil

	/// contains dpad and left side buttons
	var rightMainButtons:UInt8 = 0
	var previousRightMainButtons:UInt8 = 0

	var faceButtons:UInt8 = 0
	var previousFaceButtons:UInt8 = 0

	var xButton = false
	var previousXButton = false
	var aButton = false
	var previousAButton = false
	var bButton = false
	var previousBButton = false
	var yButton = false
	var previousYButton = false

	/// SR button on right joy-con
	var rightSideTopButton = false
	var previousRightSideTopButton = false

	/// SL on right joy-con
	var rightSideBottomButton = false
	var previousRightSideBottomButton = false

	/// contains left shoulder, left trigger, minus, capture and stick buttons
	var rightSecondaryButtons:UInt8 = 0
	var previousRightSecondaryButtons:UInt8 = 0

	// shoulder buttons
	var rightShoulderButton = false
	var previousRightShoulderButton = false
	var rightTriggerButton = false
	var previousRightTriggerButton = false

	// other buttons

	var plusButton = false
	var previousPlusButton = false

	var homeButton = false
	var previousHomeButton = false

	// analog buttons (thumbstick only for joy-cons)
	// notice that the simpified report only gives us 8 directions, not analog data

	var rightStickButton = false
	var previousRightStickButton = false

	// 8 direction stick data
	var rightStick:UInt8 = 0
	var previousRightStick:UInt8 = 0

	// analog stick data
	var rightStickX:Int16 = 0
	var previousRightStickX:Int16 = 0
	var rightStickY:Int16 = 0
	var previousRightStickY:Int16 = 0

	// inertial measurement unit (imu)

	var rightGyroPitch:Int32 = 0
	var rightPreviousGyroPitch:Int32 = 0
	var rightGyroYaw:Int32 = 0
	var rightPreviousGyroYaw:Int32 = 0
	var rightGyroRoll:Int32 = 0
	var rightPreviousGyroRoll:Int32 = 0

	var rightAccelX:Int32 = 0
	var rightPreviousAccelX:Int32 = 0
	var rightAccelY:Int32 = 0
	var rightPreviousAccelY:Int32 = 0
	var rightAccelZ:Int32 = 0
	var rightPreviousAccelZ:Int32 = 0

	// battery
	var batteryRightCharging = false
	var batteryRightLevel:UInt8 = 0
	var previousBatteryRightLevel:UInt8 = 0

	// TODO
	//var cableConnected = false

	// MARK: - Methods

	init(_ device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.id = JoyConController.nextId
		JoyConController.nextId = JoyConController.nextId + 1

		self.setDevice(device, productID:productID, transport:transport)

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

	}

	func setDevice(_ device:IOHIDDevice, productID:Int64, transport:String/*, enableIMUReport:Bool*/) {

		self.transport = transport
		if self.transport == "Bluetooth" {
			self.isBluetooth = true
		}

		self.productID = productID

		if productID == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {

			self.rightDevice = device
			IOHIDDeviceOpen(self.rightDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
			let success = self.sendReport(led1On: true)

			if !success {
				print("Error setting LED")
			}

		} else {

			self.leftDevice = device
			IOHIDDeviceOpen(self.leftDevice!, IOOptionBits(kIOHIDOptionsTypeNone)) // or kIOHIDManagerOptionUsePersistentProperties
			let success = self.sendReport(led1On: true)

			if !success {
				print("Error setting LED")
			}

			// TODO send format with 0x11, before enabling accelerometer report
			print("Enabled IMU: \(self.toggleIMU(enable: true))")
			print("Enabled Vibration: \(self.toggleVibration(enable: true))")
			print("Enabled IMU report: \(self.changeInputReportId(JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO))")

			/*
			// Increase data rate for Bluetooth
			if (bluetooth)
			{
				memset(buf, 0x00, 0x400);
				buf[0] = 0x31; // Enabled
				joycon_send_subcommand(handle, 0x1, 0x3, buf, 1);
			}
			*/

		}

	}

	/// Gets called by GamePadMonitor
	func parseReport(_ report:Data, controllerType:Int64) {

		// report[0] // the report type

		let bluetoothOffset = self.isBluetooth ? 0 : 10

		if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_LEFT {

			// MARK: left joycon input report

			if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS {

				// MARK: left joycon simple input report

				// MARK: left digital buttons

				self.leftMainButtons = report[1 + bluetoothOffset]

				self.batteryLeftLevel = (leftMainButtons & 0b1111_0000) >> 4

				self.directionalPad = leftMainButtons & 0b0000_1111

				self.upButton    = self.directionalPad & 0b0000_0100 == 0b0000_0100
				self.rightButton = self.directionalPad & 0b0000_1000 == 0b0000_1000
				self.downButton  = self.directionalPad & 0b0000_0010 == 0b0000_0010
				self.leftButton  = self.directionalPad & 0b0000_0001 == 0b0000_0001

				self.leftSideTopButton    = leftMainButtons & 0b0001_0000 == 0b0001_0000
				self.leftSideBottomButton = leftMainButtons & 0b0010_0000 == 0b0010_0000

				self.leftSecondaryButtons = report[2 + bluetoothOffset]

				self.leftShoulderButton = leftSecondaryButtons & 0b0100_0000 == 0b0100_0000
				self.leftTriggerButton  = leftSecondaryButtons & 0b1000_0000 == 0b1000_0000

				self.minusButton        = leftSecondaryButtons & 0b0000_0001 == 0b0000_0001
				self.captureButton      = leftSecondaryButtons & 0b0010_0000 == 0b0010_0000

				self.leftStickButton    = leftSecondaryButtons & 0b0000_0100 == 0b0000_0100

				if leftMainButtons != self.previousLeftMainButtons
					|| leftSecondaryButtons != self.previousLeftSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								leftSideTopButton: self.leftSideTopButton,
								leftSideBottomButton: self.leftSideBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								trackPadButton: false,
								centralButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								rightSideBottomButton: self.rightSideBottomButton,
								rightSideTopButton: self.rightSideTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousLeftMainButtons = self.leftMainButtons

					self.previousDirectionalPad = self.directionalPad

					self.previousUpButton = self.upButton
					self.previousRightButton = self.rightButton
					self.previousDownButton = self.downButton
					self.previousLeftButton = self.leftButton

					self.previousLeftSideTopButton = self.leftSideTopButton
					self.previousLeftSideBottomButton = self.leftSideBottomButton

					self.previousLeftSecondaryButtons = self.leftSecondaryButtons

					self.previousLeftShoulderButton = self.leftShoulderButton
					self.previousLeftTriggerButton = self.leftTriggerButton

					self.previousMinusButton = self.minusButton
					self.previousCaptureButton = self.captureButton

					self.previousLeftStickButton = self.leftStickButton

				}

				self.leftStick = report[3 + bluetoothOffset]

				// MARK: left analog buttons
				// origin left top for compatibility with other controllers

				if self.leftStick        == JoyConLeftDirection.right.rawValue || self.leftStick == JoyConLeftDirection.rightUp.rawValue || self.leftStick == JoyConLeftDirection.rightDown.rawValue {
					self.leftStickX = 1
				} else if self.leftStick == JoyConLeftDirection.left.rawValue  || self.leftStick == JoyConLeftDirection.leftUp.rawValue  || self.leftStick == JoyConLeftDirection.leftDown.rawValue {
					self.leftStickX = -1
				} else {
					self.leftStickX = 0
				}

				if self.leftStick        == JoyConLeftDirection.down.rawValue || self.leftStick == JoyConLeftDirection.leftDown.rawValue || self.leftStick == JoyConLeftDirection.rightDown.rawValue {
					self.leftStickY = 1
				} else if self.leftStick == JoyConLeftDirection.up.rawValue   || self.leftStick == JoyConLeftDirection.leftUp.rawValue   || self.leftStick == JoyConLeftDirection.rightUp.rawValue {
					self.leftStickY = -1
				} else {
					self.leftStickY = 0
				}

				if self.previousLeftStickX != self.leftStickX
					|| self.previousLeftStickY != self.leftStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: 2,
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousLeftStickX = self.leftStickX
					self.previousLeftStickY = self.leftStickY

				}

			} else if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO {

				// MARK: left joycon gyro input report

				// print(report[1]) // increments in 3
				// print(report[2]) // 0x8E 142
				// print(report[3]) // 0

				// MARK: left digital buttons

				self.leftMainButtons = report[5 + bluetoothOffset] // TODO not sure about bluetooth offset for tihs report

				self.directionalPad = leftMainButtons & 0b0000_1111

				self.upButton    = self.directionalPad & 0b0000_0010 == 0b0000_0010
				self.rightButton = self.directionalPad & 0b0000_0100 == 0b0000_0100
				self.downButton  = self.directionalPad & 0b0000_0001 == 0b0000_0001
				self.leftButton  = self.directionalPad & 0b0000_1000 == 0b0000_1000

				self.leftSideTopButton    = leftMainButtons & 0b0010_0000 == 0b0010_0000
				self.leftSideBottomButton = leftMainButtons & 0b0001_0000 == 0b0001_0000

				self.leftShoulderButton = leftMainButtons & 0b0100_0000 == 0b0100_0000
				self.leftTriggerButton  = leftMainButtons & 0b1000_0000 == 0b1000_0000

				self.minusButton     = self.leftSecondaryButtons & 0b0000_0001 == 0b0000_0001
				self.leftStickButton = self.leftSecondaryButtons & 0b0000_1000 == 0b0000_1000
				self.captureButton   = self.leftSecondaryButtons & 0b0010_0000 == 0b0010_0000

				if leftMainButtons != self.previousLeftMainButtons
					|| leftSecondaryButtons != self.previousLeftSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								leftSideTopButton: self.leftSideTopButton,
								leftSideBottomButton: self.leftSideBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								trackPadButton: false,
								centralButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								rightSideBottomButton: self.rightSideBottomButton,
								rightSideTopButton: self.rightSideTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousLeftMainButtons = self.leftMainButtons

					self.previousDirectionalPad = self.directionalPad

					self.previousUpButton = self.upButton
					self.previousRightButton = self.rightButton
					self.previousDownButton = self.downButton
					self.previousLeftButton = self.leftButton

					self.previousLeftSideTopButton = self.leftSideTopButton
					self.previousLeftSideBottomButton = self.leftSideBottomButton

					self.previousLeftSecondaryButtons = self.leftSecondaryButtons

					self.previousLeftShoulderButton = self.leftShoulderButton
					self.previousLeftTriggerButton = self.leftTriggerButton

					self.previousMinusButton = self.minusButton
					self.previousCaptureButton = self.captureButton

					self.previousLeftStickButton = self.leftStickButton

				}

				// print("report[9]:  \(report[9])")  // always 0!?
				// print("report[10]: \(report[10])") // always 0!?
				// print("report[11]: \(report[11])") // always 0!?

				// print("report[12]: \(report[12])") // always 192!?

				// MARK: left analog buttons

				// TODO calibrate
				self.leftStickX = Int16(report[7] & 0b0000_1111) << 8 | Int16(report[6]) // 12 bits actually
				self.leftStickY = Int16(report[8]) << 4 | Int16(report[7]) >> 4 // 12 bits actually

				if self.previousLeftStickX != self.leftStickX
					|| self.previousLeftStickY != self.leftStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: UInt16(JoyConController.MAX_STICK), // 12 bits
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousLeftStickX = self.leftStickX
					self.previousLeftStickY = self.leftStickY

				}

				// MARK: left inertial movement unit (imu)

				// ?? The controller sends the sensor data 3 times with a little bit different values. Skip them

				// ?? gyroscope data is in rad/s
				self.leftGyroPitch = Int32(report[20 + bluetoothOffset]) << 8 | Int32(report[19 + bluetoothOffset]) // TODO calibrate
				self.leftGyroYaw   = Int32(report[22 + bluetoothOffset]) << 8 | Int32(report[21 + bluetoothOffset]) // TODO calibrate
				self.leftGyroRoll  = Int32(report[24 + bluetoothOffset]) << 8 | Int32(report[23 + bluetoothOffset]) // TODO calibrate

				// ?? accelerometer data is in m/s²
				self.leftAccelX = Int32(report[14 + bluetoothOffset]) << 8 | Int32(report[13 + bluetoothOffset]) // TODO calibrate
				self.leftAccelY = Int32(report[16 + bluetoothOffset]) << 8 | Int32(report[15 + bluetoothOffset]) // TODO calibrate
				self.leftAccelZ = Int32(report[18 + bluetoothOffset]) << 8 | Int32(report[17 + bluetoothOffset]) // TODO calibrate

				/*
				jc->accel.x = (float)(uint16_to_int16(packet[13] | (packet[14] << 8) & 0xFF00)) * jc->acc_cal_coeff[0];

				jc->gyro.roll	= (float)((uint16_to_int16(packet[19] | (packet[20] << 8) & 0xFF00)) - jc->sensor_cal[1][0]) * jc->gyro_cal_coeff[0];
				jc->gyro.pitch	= (float)((uint16_to_int16(packet[21] | (packet[22] << 8) & 0xFF00)) - jc->sensor_cal[1][1]) * jc->gyro_cal_coeff[1];
				jc->gyro.yaw	= (float)((uint16_to_int16(packet[23] | (packet[24] << 8) & 0xFF00)) - jc->sensor_cal[1][2]) * jc->gyro_cal_coeff[2];

				// offsets:
				{
					jc->setGyroOffsets();

					jc->gyro.roll	-= jc->gyro.offset.roll;
					jc->gyro.pitch	-= jc->gyro.offset.pitch;
					jc->gyro.yaw	-= jc->gyro.offset.yaw;

					//tracker.counter1++;
					//if (tracker.counter1 > 10) {
					//	tracker.counter1 = 0;
					//	printf("%.3f %.3f %.3f\n", abs(jc->gyro.roll), abs(jc->gyro.pitch), abs(jc->gyro.yaw));
					//}
				}
				*/




				print("report[25]: \(report[25])")
				print("report[26]: \(report[26])")
				print("report[27]: \(report[27])")
				print("report[28]: \(report[28])")
				print("report[29]: \(report[29])")

				print("report[30]: \(report[30])")
				print("report[31]: \(report[31])")
				print("report[32]: \(report[32])")
				print("report[33]: \(report[33])")
				print("report[34]: \(report[34])")
				print("report[35]: \(report[35])")
				print("report[36]: \(report[36])")
				print("report[37]: \(report[37])")
				print("report[38]: \(report[38])")
				print("report[39]: \(report[39])")

				print("report[40]: \(report[40])")
				print("report[41]: \(report[41])")
				print("report[42]: \(report[42])")
				print("report[43]: \(report[43])")
				print("report[44]: \(report[44])")
				print("report[45]: \(report[45])")
				print("report[46]: \(report[46])")
				print("report[47]: \(report[47])")
				print("report[48]: \(report[48])")

			}

		} else if controllerType == JoyConController.CONTROLLER_ID_JOY_CON_RIGHT {


			// MARK: right joycon input report

			if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS {

				// MARK: right joycon simple input report

				// MARK: right digital buttons

				self.rightMainButtons = report[1 + bluetoothOffset]

				self.batteryRightLevel = (rightMainButtons & 0b1111_0000) >> 4

				self.faceButtons = rightMainButtons & 0b0000_1111

				self.xButton = self.faceButtons & 0b0000_0010 == 0b0000_0010
				self.aButton = self.faceButtons & 0b0000_0001 == 0b0000_0001
				self.bButton = self.faceButtons & 0b0000_0100 == 0b0000_0100
				self.yButton = self.faceButtons & 0b0000_1000 == 0b0000_1000

				self.rightSideTopButton    = rightMainButtons & 0b0010_0000 == 0b0010_0000
				self.rightSideBottomButton = rightMainButtons & 0b0001_0000 == 0b0001_0000

				self.rightSecondaryButtons = report[2 + bluetoothOffset]

				self.rightShoulderButton = rightSecondaryButtons & 0b0100_0000 == 0b0100_0000
				self.rightTriggerButton  = rightSecondaryButtons & 0b1000_0000 == 0b1000_0000

				print(String(rightSecondaryButtons, radix: 2))

				self.plusButton          = rightSecondaryButtons & 0b0000_0010 == 0b0000_0010
				self.homeButton          = rightSecondaryButtons & 0b0001_0000 == 0b0001_0000

				self.rightStickButton    = rightSecondaryButtons & 0b0000_1000 == 0b0000_1000

				if rightMainButtons != self.previousRightMainButtons
					|| rightSecondaryButtons != self.previousRightSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								leftSideTopButton: self.leftSideTopButton,
								leftSideBottomButton: self.leftSideBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								trackPadButton: false,
								centralButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								rightSideBottomButton: self.rightSideBottomButton,
								rightSideTopButton: self.rightSideTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousRightMainButtons = self.rightMainButtons

					self.previousFaceButtons = self.faceButtons

					self.previousXButton = self.xButton
					self.previousAButton = self.aButton
					self.previousBButton = self.bButton
					self.previousYButton = self.yButton

					self.previousRightSideTopButton = self.rightSideTopButton
					self.previousRightSideBottomButton = self.rightSideBottomButton

					self.previousRightSecondaryButtons = self.rightSecondaryButtons

					self.previousRightShoulderButton = self.rightShoulderButton
					self.previousRightTriggerButton = self.rightTriggerButton

					self.previousPlusButton = self.plusButton
					self.previousHomeButton = self.homeButton

					self.previousRightStickButton = self.rightStickButton

				}

				self.rightStick = report[3 + bluetoothOffset]

				// MARK: right analog buttons
				// origin left top for compatibility with other controllers

				if self.rightStick        == JoyConRightDirection.right.rawValue || self.rightStick == JoyConRightDirection.rightUp.rawValue || self.rightStick == JoyConRightDirection.rightDown.rawValue {
					self.rightStickX = 1
				} else if self.rightStick == JoyConRightDirection.left.rawValue  || self.rightStick == JoyConRightDirection.leftUp.rawValue  || self.rightStick == JoyConRightDirection.leftDown.rawValue {
					self.rightStickX = -1
				} else {
					self.rightStickX = 0
				}

				if self.rightStick        == JoyConRightDirection.down.rawValue || self.rightStick == JoyConRightDirection.leftDown.rawValue || self.rightStick == JoyConRightDirection.rightDown.rawValue {
					self.rightStickY = 1
				} else if self.rightStick == JoyConRightDirection.up.rawValue   || self.rightStick == JoyConRightDirection.leftUp.rawValue   || self.rightStick == JoyConRightDirection.rightUp.rawValue {
					self.rightStickY = -1
				} else {
					self.rightStickY = 0
				}

				if self.previousRightStickX != self.rightStickX
					|| self.previousRightStickY != self.rightStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: 2,
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousRightStickX = self.rightStickX
					self.previousRightStickY = self.rightStickY

				}

			} else if report[0] == JoyConController.INPUT_REPORT_ID_BUTTONS_GYRO {

				// MARK: right joycon gyro input report

				// print(report[1]) // increments in 3
				// print(report[2]) // 0x8E 142
				// print(report[3]) // 0

				// MARK: right digital buttons

				self.rightMainButtons = report[5 + bluetoothOffset] // TODO not sure about bluetooth offset for tihs report

				self.faceButtons = rightMainButtons & 0b0000_1111

				// TODO check these
				self.yButton = self.faceButtons & 0b0000_0010 == 0b0000_0010
				self.xButton = self.faceButtons & 0b0000_0100 == 0b0000_0100
				self.aButton = self.faceButtons & 0b0000_0001 == 0b0000_0001
				self.bButton = self.faceButtons & 0b0000_1000 == 0b0000_1000

				self.rightSideTopButton    = rightMainButtons & 0b0010_0000 == 0b0010_0000
				self.rightSideBottomButton = rightMainButtons & 0b0001_0000 == 0b0001_0000

				self.rightShoulderButton = rightMainButtons & 0b0100_0000 == 0b0100_0000
				self.rightTriggerButton  = rightMainButtons & 0b1000_0000 == 0b1000_0000

				self.rightSecondaryButtons = report[4 + bluetoothOffset]

				self.plusButton       = self.rightSecondaryButtons & 0b0000_0001 == 0b0000_0001
				self.rightStickButton = self.rightSecondaryButtons & 0b0000_1000 == 0b0000_1000
				self.homeButton       = self.rightSecondaryButtons & 0b0010_0000 == 0b0010_0000

				if rightMainButtons != self.previousRightMainButtons
					|| rightSecondaryButtons != self.previousRightSecondaryButtons
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadButtonChangedNotification.Name,
							object: GamepadButtonChangedNotification(
								leftTriggerButton: self.leftTriggerButton,
								leftShoulderButton: self.leftShoulderButton,
								minusButton: self.minusButton,
								leftSideTopButton: self.leftSideTopButton,
								leftSideBottomButton: self.leftSideBottomButton,
								upButton: self.upButton,
								rightButton: self.rightButton,
								downButton: self.downButton,
								leftButton: self.leftButton,
								socialButton: self.captureButton,
								leftStickButton: self.leftStickButton,
								trackPadButton: false,
								centralButton: false,
								rightStickButton: self.rightStickButton,
								rightAuxiliaryButton: self.homeButton,
								faceNorthButton: self.xButton,
								faceEastButton: self.aButton,
								faceSouthButton: self.bButton,
								faceWestButton: self.yButton,
								rightSideBottomButton: self.rightSideBottomButton,
								rightSideTopButton: self.rightSideTopButton,
								plusButton: self.plusButton,
								rightShoulderButton: self.rightShoulderButton,
								rightTriggerButton: self.rightTriggerButton
							)
						)
					}

					self.previousRightMainButtons = self.rightMainButtons

					self.previousFaceButtons = self.faceButtons

					self.previousXButton = self.xButton
					self.previousAButton = self.aButton
					self.previousBButton = self.bButton
					self.previousYButton = self.yButton

					self.previousRightSideTopButton = self.rightSideTopButton
					self.previousRightSideBottomButton = self.rightSideBottomButton

					self.previousRightSecondaryButtons = self.rightSecondaryButtons

					self.previousRightShoulderButton = self.rightShoulderButton
					self.previousRightTriggerButton = self.rightTriggerButton

					self.previousPlusButton = self.plusButton
					self.previousHomeButton = self.homeButton

					self.previousRightStickButton = self.rightStickButton

				}

				// print("report[9]:  \(report[9])")  // always 0!?
				// print("report[10]: \(report[10])") // always 0!?
				// print("report[11]: \(report[11])") // always 0!?

				// print("report[12]: \(report[12])") // always 192!?

				// MARK: right analog buttons

				// TODO calibrate
				self.rightStickX = Int16(report[7] & 0b0000_1111) << 8 | Int16(report[6]) // 12 bits actually
				self.rightStickY = Int16(report[8]) << 4 | Int16(report[7]) >> 4 // 12 bits actually

				if self.previousRightStickX != self.rightStickX
					|| self.previousRightStickY != self.rightStickY
				{

					DispatchQueue.main.async {
						NotificationCenter.default.post(
							name: GamepadAnalogChangedNotification.Name,
							object: GamepadAnalogChangedNotification(
								leftStickX: UInt16(self.leftStickX),
								leftStickY: UInt16(self.leftStickY),
								rightStickX: UInt16(self.rightStickX),
								rightStickY: UInt16(self.rightStickY),
								stickMax: UInt16(JoyConController.MAX_STICK), // 12 bits
								leftTrigger: self.leftTriggerButton ? UInt16(UInt8.max) : 0,
								rightTrigger: self.rightTriggerButton ? UInt16(UInt8.max) : 0,
								triggerMax: UInt16(UInt8.max)
							)
						)
					}

					self.previousRightStickX = self.rightStickX
					self.previousRightStickY = self.rightStickY

				}

			}

			// TODO IR

			// TODO NFC


		}

		// 4-7 (Pro Con) 	x40 8A 4F 8A 	Left analog stick data
		// 8-11 (Pro Con) 	xD0 7E DF 7F 	Right analog stick data
		// for joy-cons this can be ignored

	}

	// MARK: - Output reports

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

		self.sendReport(
			led1On: o.led1On,
			led2On: o.led2On,
			led3On: o.led3On,
			led4On: o.led4On,
			blinkLed1: o.blinkLed1,
			blinkLed2: o.blinkLed2,
			blinkLed3: o.blinkLed3,
			blinkLed4: o.blinkLed4
			// TODO home led...
		)

	}

	func toggleVibration(enable:Bool) -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_TOGGLE_VIBRATION

		// sub report type parameter 1
		buffer[11] = enable ? 0x01 : 0x00

		let success = IOHIDDeviceSetReport(
			self.leftDevice!,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	func toggleIMU(enable:Bool) -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_TOGGLE_IMU

		// sub report type parameter 1
		buffer[11] = enable ? 0x01 : 0x00

		let toggleSuccess = IOHIDDeviceSetReport(
			self.leftDevice!,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		/*
		Enabling IMU if it was previously disabled
		resets your configuration to Acc: 1.66 kHz (high perf), ±8G, 100 Hz Anti-aliasing filter bandwidth
		and Gyro: 208 Hz (high performance), ±2000dps..

		So I'm resetting to my own settings. That are more similar to DualShock 4
		*/

		let settingsSuccess = self.imuSettings()

		// TODO load calibration data from Serial Peripheral Interface (SPI)

		if toggleSuccess != kIOReturnSuccess && !settingsSuccess {
			return false
		}

		return true

	}

	func imuSettings() -> Bool {

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_IMU_SETTINGS

		// gyro sensivity
		// 00 ±250°/s
		// 01 ±500°/s
		// 02 ±1000°/s
		// 03 ±2000°/s (default) same as DualShock4 I believe
		buffer[11] = 0x03

		// accel G range
		// 00 ±8G (default)
		// 01 ±4G
		// 02 ±2G
		// 03 ±16G
		buffer[12] = 0x02 // 2G

		// gyro sampling frequency??
		// 00 833Hz (high perf)
		// 01 208Hz (high perf, default)
		buffer[13] = 0x01

		// accel anti-aliasing filter bandwidth
		// 00 200Hz
		// 01 100Hz (default)
		buffer[14] = 0x01

		let success = IOHIDDeviceSetReport(
			self.leftDevice!,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	func changeInputReportId(_ reportId:UInt8) -> Bool {

		// TODO

		/*
		// Set input report mode (to push at 60hz)
		// x00	Used with cmd x11. Active polling for NFC/IR camera data. 0x31 data format must be set first. Answers with more than 300 bytes ID 31 packet
		// x01	Same as 00. Active polling mode for NFC/IR MCU configuration data.
		// x02	Same as 00. Active polling mode for NFC/IR data and configuration. For specific NFC/IR modes. Active polling mode for IR camera data. Special IR mode or before configuring it ?
		// x03 	Same as 00. Active polling mode for IR camera data. For specific IR modes.

		// x21	Unknown. An input report with this ID has pairing or mcu data or serial flash data or device info
		// x23	MCU update input report ?

		x33 	Unknown mode.
		x35 	Unknown mode.
		*/

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_SET_INPUT_REPORT_ID

		// sub report type parameter 1
		buffer[11] = reportId

		let success = IOHIDDeviceSetReport(
			self.leftDevice!,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

	// TODO
	func getBattery() {

		/*
		Subcommand 0x50: Get regulated voltage

		Replies with ACK xD0 x50 and a little-endian uint16. Raises when charging a Joy-Con.
		Internally, the values come from 1000mV - 1800mV regulated voltage samples, that are translated to 1320-1680 values.
		These follow a curve between 3.3V and 4.2V (tested with multimeter). So a 2.5x multiplier can get us the real battery voltage in mV.
		Based on this info, we have the following table:
		Range # 	Range 	Range in mV 	Reported battery
		x0528 - x059F 	1320 - 1439 	3300 - 3599 	2 - Critical
		x05A0 - x05DF 	1440 - 1503 	3600 - 3759 	4 - Low
		x05E0 - x0617 	1504 - 1559 	3760 - 3899 	6 - Medium
		x0618 - x0690 	1560 - 1680 	3900 - 4200 	8 - Full

		Tests showed charging stops at 1680 and the controller turns off at 1320.
		*/

	}

	func sendReport(
		led1On:Bool = false,
		led2On:Bool = false,
		led3On:Bool = false,
		led4On:Bool = false,
		blinkLed1:Bool = false,
		blinkLed2:Bool = false,
		blinkLed3:Bool = false,
		blinkLed4:Bool = false
		// TODO home led...
	) -> Bool {

		/*
		OUTPUT 0x01

		Rumble and subcommand.

		The OUTPUT 1 report is how all normal subcommands are sent. It also includes rumble data.

		Sample C code for sending a subcommand:

		uint8_t buf[0x40]; bzero(buf, 0x40);
		buf[0] = 1; // 0x10 for rumble only
		buf[1] = GlobalPacketNumber; // Increment by 1 for each packet sent. It loops in 0x0 - 0xF range.
		memcpy(buf + 2, rumbleData, 8);
		buf[10] = subcommandID;
		memcpy(buf + 11, subcommandData, subcommandDataLen);
		hid_write(handle, buf, 0x40);

		You can send rumble data and subcommand with x01 command, otherwise only rumble with x10 command.

		See "Rumble data" below.

		OUTPUT 0x10
		Rumble only. See OUTPUT 0x01 and "Rumble data" below.





		Subcommand 0x38: Set HOME Light

		25 bytes argument that control 49 elements.
		Byte #, Nibble 	Remarks
		x00, High 	Number of Mini Cycles. 1-15. If number of cycles is > 0 then x0 = x1
		x00, Low 	Global Mini Cycle Duration. 8ms - 175ms. Value x0 = 0ms/OFF
		x01, High 	LED Start Intensity. Value x0=0% - xF=100%
		x01, Low 	Number of Full Cycles. 1-15. Value x0 is repeat forever, but if also Byte x00 High nibble is set to x0, it does the 1st Mini Cycle and then the LED stays on with LED Start Intensity.

		When all selected Mini Cycles play and then end, this is a full cycle.

		The Mini Cycle configurations are grouped in two (except the 15th):
		Byte #, Nibble 	Remarks
		x02, High 	Mini Cycle 1 LED Intensity
		x02, Low 	Mini Cycle 2 LED Intensity
		x03, High 	Fading Transition Duration to Mini Cycle 1 (Uses PWM). Value is a Multiplier of Global Mini Cycle Duration
		x03, Low 	LED Duration Multiplier of Mini Cycle 1. x0 = x1 = x1
		x04, High 	Fading Transition Duration to Mini Cycle 2 (Uses PWM). Value is a Multiplier of Global Mini Cycle Duration
		x04, Low 	LED Duration Multiplier of Mini Cycle 1. x0 = x1 = x1

		The Fading Transition uses a PWM to increment the transition to the Mini Cycle.

		The LED Duration Multiplier and the Fading Multiplier use the same algorithm: Global Mini Cycle Duration ms * Multiplier value.

		Example: GMCD is set to xF = 175ms and LED Duration Multiplier is set to x4. The Duration that the LED will stay on it's configured intensity is then 175 * 4 = 700ms.

		Unused Mini Cycles can be skipped from the output packet.

		Table of Mini Cycle configuration:
		Byte #, Nibble 	Remarks
		x02, High 	Mini Cycle 1 LED Intensity
		x02, Low 	Mini Cycle 2 LED Intensity
		x03 High/Low 	Fading/LED Duration Multipliers for MC 1
		x04 High/Low 	Fading/LED Duration Multipliers for MC 2
		x05, High 	Mini Cycle 3 LED Intensity
		x05, Low 	Mini Cycle 4 LED Intensity
		x06 High/Low 	Fading/LED Duration Multipliers for MC 3
		x06 High/Low 	Fading/LED Duration Multipliers for MC 4
		... 	...
		x20, High 	Mini Cycle 13 LED Intensity
		x20, Low 	Mini Cycle 14 LED Intensity
		x21 High/Low 	Fading/LED Duration Multipliers for MC 13
		x22 High/Low 	Fading/LED Duration Multipliers for MC 14
		x23, High 	Mini Cycle 15 LED Intensity
		x23, Low 	Unused
		x24 High/Low 	Fading/LED Duration Multipliers for MC 15
		*/

		var buffer = [UInt8](repeating: 0, count: 49)

		buffer[0] = JoyConController.OUTPUT_REPORT_ID_RUMBLE_SEND_SUB_TYPE
		buffer[1] = JoyConController.outputReportIterator

		// neutral rumble left
		buffer[2] = 0x00
		buffer[3] = 0x01
		buffer[4] = 0x40
		buffer[5] = 0x40

		// neutral rumble right
		buffer[6] = 0x00
		buffer[7] = 0x10
		buffer[8] = 0x40
		buffer[9] = 0x40

		// sub report type or sub command
		buffer[10] = JoyConController.OUTPUT_REPORT_SUB_ID_SET_PLAYER_LIGHTS

		/*
		Subcommand Get player lights
		Replies with ACK xB0 x31 and one byte that uses the same bitfield with x30 subcommand
		The initial LED trail effects is 10110001 (xB1), but it cannot be set via x30. subcommand
		*/

		var leds:UInt8 = 0b0000_0000

		if led1On {
			leds = leds | 0b0000_0001
		}

		if led2On {
			leds = leds | 0b0000_0010
		}

		if led3On {
			leds = leds | 0b0000_0100
		}

		if led4On {
			leds = leds | 0b0000_1000
		}

		// "on" bits override "flash" bits. When on USB, "flash" bits work like "on" bits.

		if blinkLed1 {
			leds = leds | 0b0001_0000
		}
		if blinkLed2 {
			leds = leds | 0b0010_0000
		}
		if blinkLed3 {
			leds = leds | 0b0100_0000
		}
		if blinkLed4 {
			leds = leds | 0b1000_0000
		}

		// sub report type parameter 1
		buffer[11] = leds

		let success = IOHIDDeviceSetReport(
			self.leftDevice!,
			kIOHIDReportTypeOutput,
			Int(buffer[0]), // Report ID
			buffer,
			buffer.count
		);

		JoyConController.outputReportIterator = JoyConController.outputReportIterator &+ 1

		if success != kIOReturnSuccess {
			return false
		}

		return true

	}

}
