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

	var leftButton:Bool = false
	var leftTrigger:Float = 0

	var leftStickX:Float = 0
	var leftStickY:Float = 0
	var rightStickX:Float = 0
	var rightStickY:Float = 0

	var rightButton:Bool = false
	var rightTrigger:Float = 0

	let objectWillChange = ObservableObjectPublisher()

	init() {

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateButtons),
				name: GamePadButtonChangedNotification.Name,
				object: nil
			)

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateAnalog),
				name: GamePadAnalogChangedNotification.Name,
				object: nil
			)

	}

	@objc func updateButtons(_ notification:Notification) {

		let o = notification.object as! GamePadButtonChangedNotification

		self.leftButton = o.leftButton
		self.rightButton = o.rightButton

		objectWillChange.send()

	}

	@objc func updateAnalog(_ notification:Notification) {

		let o = notification.object as! GamePadAnalogChangedNotification

		self.leftTrigger = Float(o.leftTrigger)

		self.leftStickX = Float(o.leftStickX)
		self.leftStickY = Float(o.leftStickY)

		self.rightStickX = Float(o.rightStickX)
		self.rightStickY = Float(o.rightStickY)

		self.rightTrigger = Float(o.rightTrigger)

		objectWillChange.send()

	}

}
