//
//  Xbox360UIModel.swift
//  GamePad
//
//  Created by Marco Luglio on 15/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation
import Combine



class XboxSeriesXSUIModel: ObservableObject {

	var leftTrigger:Float = 0
	var leftTriggerButton = false
	var leftShoulderButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var backButton = false

	var xboxButton = false
	var uploadButton = false

	var startButton = false

	var rightStickX:Float = 0
	var rightStickY:Float = 0
	var rightStickButton = false

	var yButton = false
	var bButton = false
	var aButton = false
	var xButton = false

	var rightShoulderButton = false
	var rightTriggerButton = false
	var rightTrigger:Float = 0

	// TODO LED here

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

		/*NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateLed),
				name: Xbox360ChangeLedNotification.Name,
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
		self.upButton = o.upButton
		self.rightButton = o.rightButton
		self.downButton = o.downButton
		self.leftButton = o.leftButton
		self.backButton = o.socialButton
		self.leftStickButton = o.leftStickButton
		self.xboxButton = o.centralButton
		self.rightStickButton = o.rightStickButton
		self.startButton = o.rightAuxiliaryButton
		self.yButton = o.faceNorthButton
		self.bButton = o.faceEastButton
		self.aButton = o.faceSouthButton
		self.xButton = o.faceWestButton
		self.rightShoulderButton = o.rightShoulderButton
		self.rightTriggerButton = o.rightTriggerButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamepadAnalogChangedNotification

		self.leftTrigger = Float32(o.leftTrigger) * 256 / Float32(o.triggerMax)

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

	/*
	@objc func updateLed(_ notification:Notification) {

		let o = notification.object as! Xbox360ChangeLedNotification

		self.red = Double(o.red) // pattern here

		objectWillChange.send()

	}
	*/

	@objc func updateBattery(_ notification:Notification) {

		let o = notification.object as! GamepadBatteryChangedNotification

		self.battery = Float(o.battery)
		self.isConnected = o.isConnected
		self.isCharging = o.isCharging

		objectWillChange.send()

	}

}
