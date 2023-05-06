//
//  Xbox360UIModel.swift
//  GamePad
//
//  Created by Marco Luglio on 15/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import Combine



class JoyConUIModel: ObservableObject {

	var leftTrigger:Float = 0
	var leftTriggerButton = false
	var leftShoulderButton = false

	var minusButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0

	var leftSideTopButton = false

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var captureButton = false

	var leftSideBottomButton = false
	var rightSideBottomButton = false

	var leftGyroPitch:Int32 = 0
	var leftGyroYaw:Int32 = 0
	var leftGyroRoll:Int32 = 0

	var leftAccelX:Float32 = 0
	var leftAccelY:Float32 = 0
	var leftAccelZ:Float32 = 0



	var homeButton = false

	var rightStickX:Float = 0
	var rightStickY:Float = 0
	var rightStickButton = false

	var rightSideTopButton = false

	var xButton = false
	var aButton = false
	var bButton = false
	var yButton = false

	var plusButton = false

	var rightShoulderButton = false
	var rightTriggerButton = false
	var rightTrigger:Float = 0

	var rightGyroPitch:Int32 = 0
	var rightGyroYaw:Int32 = 0
	var rightGyroRoll:Int32 = 0

	var rightAccelX:Float32 = 0
	var rightAccelY:Float32 = 0
	var rightAccelZ:Float32 = 0

	var isConnected = false
	var isCharging = false
	var leftBattery:Float = 0
	var rightBattery:Float = 0

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

		/*NotificationCenter.default
		.addObserver(
			self,
			selector: #selector(self.updateLed),
			name: JoyConChangeLedNotification.Name,
			object: nil
		)*/

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
		self.minusButton = o.minusButton
		self.leftStickButton = o.leftStickButton
		self.leftSideTopButton = o.backLeftTopButton
		self.upButton = o.upButton
		self.rightButton = o.rightButton
		self.downButton = o.downButton
		self.leftButton = o.leftButton
		self.captureButton = o.socialButton
		self.leftSideBottomButton = o.backLeftBottomButton
		self.rightSideBottomButton = o.backRightBottomButton
		self.homeButton = o.rightAuxiliaryButton
		self.rightStickButton = o.rightStickButton
		self.rightSideTopButton = o.backRightTopButton
		self.xButton = o.faceNorthButton
		self.aButton = o.faceEastButton
		self.bButton = o.faceSouthButton
		self.yButton = o.faceWestButton
		self.plusButton = o.plusButton
		self.rightShoulderButton = o.rightShoulderButton
		self.rightTriggerButton = o.rightTriggerButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamepadAnalogChangedNotification

		self.leftTrigger = Float(o.leftTrigger)

		self.leftStickX = Float(o.leftStickX)
		self.leftStickY = Float(o.leftStickY)

		self.rightStickX = Float(o.rightStickX)
		self.rightStickY = Float(o.rightStickY)

		self.rightTrigger = Float(o.rightTrigger)

		objectWillChange.send()

	}

	@objc func updateIMU(_ notification:Notification) {

		let o = notification.object as! GamepadIMUChangedNotification

		// TODO right joy-con

		self.leftGyroPitch = o.gyroPitch
		self.leftGyroYaw = o.gyroYaw
		self.leftGyroRoll = o.gyroRoll

		self.leftAccelX = o.accelX
		self.leftAccelY = o.accelY
		self.leftAccelZ = o.accelZ

		objectWillChange.send()

	}

	@objc func updateBattery(_ notification:Notification) {

		let o = notification.object as! GamepadBatteryChangedNotification

		self.leftBattery = Float(o.battery) // TODO right joy-con
		self.isConnected = o.isConnected
		self.isCharging = o.isCharging

		objectWillChange.send()

	}

}
