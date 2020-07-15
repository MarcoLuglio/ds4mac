//
//  DualShock4UIModel.swift
//  GamePad
//
//  Created by Marco Luglio on 09/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import Combine



class DualShock4UIModel: ObservableObject {

	var leftTrigger:Float = 0
	var leftTriggerButton = false
	var leftShoulderButton = false

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var shareButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0
	// TODO trackpad touches
	var trackPadButton = false
	var psButton = false

	var rightStickX:Float = 0
	var rightStickY:Float = 0
	var rightStickButton = false

	var optionsButton = false

	var triangleButton = false
	var circleButton = false
	var crossButton = false
	var squareButton = false

	var rightShoulderButton = false
	var rightTriggerButton = false
	var rightTrigger:Float = 0

	var gyroPitch:Int32 = 0
	var gyroYaw:Int32 = 0
	var gyroRoll:Int32 = 0

	var accelX:Int32 = 0
	var accelY:Int32 = 0
	var accelZ:Int32 = 0

	var red:Double = 0
	var green:Double = 0
	var blue:Double = 0

	var isConnected = false
	var isCharging = false
	var battery:Float = 0

	let objectWillChange = ObservableObjectPublisher()

	init() {

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateButtons),
				name: GamepadButtonChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateAnalog),
				name: GamepadAnalogChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateIMU),
				name: GamepadIMUChangedNotification.Name,
				object: nil
			)

		// TODO trackpad
		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateTrackpad),
				name: DualShock4TouchpadChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateLedColor),
				name: DualShock4ChangeLedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateBattery),
				name: GamepadBatteryChangedNotification.Name,
				object: nil
			)

	}

	@objc func updateButtons(_ notification:Notification) {

		let o = notification.object as! GamepadButtonChangedNotification

		self.leftTriggerButton = o.leftTriggerButton
		self.leftShoulderButton = o.leftShoulderButton
		self.upButton = o.upButton
		self.rightButton = o.rightButton
		self.downButton = o.downButton
		self.leftButton = o.leftButton
		self.shareButton = o.socialButton
		self.leftStickButton = o.leftStickButton
		self.trackPadButton = o.trackPadButton
		self.psButton = o.centralButton
		self.rightStickButton = o.rightStickButton
		self.optionsButton = o.rightAuxiliaryButton
		self.triangleButton = o.faceNorthButton
		self.circleButton = o.faceEastButton
		self.crossButton = o.faceSouthButton
		self.squareButton = o.faceWestButton
		self.rightShoulderButton = o.rightShoulderButton
		self.rightTriggerButton = o.rightTriggerButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamepadAnalogChangedNotification

		self.leftTrigger = Float(o.leftTrigger)

		// scales values to fit the Coords2d size

		let coords2dSize:Float = 40;

		self.leftStickX = Float(o.leftStickX - 128) * coords2dSize / 128
		self.leftStickY = Float(o.leftStickY - 128) * coords2dSize / 128

		self.rightStickX = Float(o.rightStickX - 128) * coords2dSize / 128
		self.rightStickY = Float(o.rightStickY - 128) * coords2dSize / 128

		self.rightTrigger = Float(o.rightTrigger)

		objectWillChange.send()

	}

	@objc func updateIMU(_ notification:Notification) {

		let o = notification.object as! GamepadIMUChangedNotification

		self.gyroPitch = o.gyroPitch
		self.gyroYaw = o.gyroYaw
		self.gyroRoll = o.gyroRoll

		self.accelX = o.accelX
		self.accelY = o.accelY
		self.accelZ = o.accelZ

		objectWillChange.send()

	}

	@objc func updateTrackpad(_ notification:Notification) {

		let o = notification.object as! DualShock4TouchpadChangedNotification

		// TODO

		objectWillChange.send()

	}

	@objc func updateLedColor(_ notification:Notification) {

		let o = notification.object as! DualShock4ChangeLedNotification

		self.red = Double(o.red)
		self.green = Double(o.green)
		self.blue = Double(o.blue)

		objectWillChange.send()

	}

	@objc func updateBattery(_ notification:Notification) {

		let o = notification.object as! GamepadBatteryChangedNotification

		self.battery = Float(o.battery)
		self.isConnected = o.isConnected
		self.isCharging = o.isCharging

		objectWillChange.send()

	}

}
