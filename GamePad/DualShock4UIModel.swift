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

	var touchpadTouch0IsActive = false
	//var touchpadTouch0Id:UInt8
	var touchpadTouch0X:Int16 = 0 // 12 bits only
	var touchpadTouch0Y:Int16 = 0
	var touchpadTouch1IsActive = false
	//var touchpadTouch1Id:UInt8
	var touchpadTouch1X:Int16 = 0 // 12 bits only
	var touchpadTouch1Y:Int16 = 0

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
				selector: #selector(self.updateTouchpad),
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

		self.leftTrigger = Float32(o.leftTrigger) * 256 / Float32(o.triggerMax)

		//print("left trigger: \(o.leftTrigger)")

		// scales values to fit the Coords2d size

		let coords2dSize:Float64 = 40
		let stickMiddleValue = (Int32(o.stickMax) / 2) + 1

		self.leftStickX = Float32(Float64(Int32(o.leftStickX) - stickMiddleValue) * coords2dSize / Float64(stickMiddleValue))
		self.leftStickY = Float32(Float64(Int32(o.leftStickY) - stickMiddleValue) * coords2dSize / Float64(stickMiddleValue))
		self.rightStickX = Float32(Float64(Int32(o.rightStickX) - stickMiddleValue) * coords2dSize / Float64(stickMiddleValue))
		self.rightStickY = Float32(Float64(Int32(o.rightStickY) - stickMiddleValue) * coords2dSize / Float64(stickMiddleValue))

		self.rightTrigger = Float32(o.rightTrigger) * 256 / Float32(o.triggerMax)

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

	@objc func updateTouchpad(_ notification:Notification) {

		let o = notification.object as! DualShock4TouchpadChangedNotification

		// for details on the numbers, check the DualShock4Controller class

		self.touchpadTouch0IsActive = o.touchpadTouch0IsActive
		//self.touchpadTouch0Id = o.touchpadTouch0Id
		self.touchpadTouch0X = (o.touchpadTouch0X - 960) / 7 // (value - (1920 / 2)) / scale of the ui
		self.touchpadTouch0Y = (o.touchpadTouch0Y - 422) / 8 // (value - (943 / 2)) / scale of the ui
		self.touchpadTouch1IsActive = o.touchpadTouch1IsActive
		//self.touchpadTouch1Id = o.touchpadTouch1Id
		self.touchpadTouch1X = (o.touchpadTouch1X - 960) / 7 // (value - (1920 / 2)) / scale of the ui
		self.touchpadTouch1Y = (o.touchpadTouch1Y - 422) / 8 // (value - (943 / 2)) / scale of the ui

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
