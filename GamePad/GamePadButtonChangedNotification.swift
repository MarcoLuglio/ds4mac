//
//  GamePadButtonChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 01/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class GamePadButtonChangedNotification {

	static let Name = Notification.Name("GamePadButtonChangedNotification")

	var leftShoulderButton = false

	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	var shareButton = false

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0

	var trackPadButton = false
	var psButton = false

	var rightStickButton = false
	var rightStickX:Float = 0
	var rightStickY:Float = 0

	var optionsButton = false

	var triangleButton = false
	var circleButton = false
	var crossButton = false
	var squareButton = false

	var rightShoulderButton = false

	init(
		// left trigger digital reading
		leftShoulderButton:Bool,
		upButton:Bool,
		rightButton:Bool,
		downButton:Bool,
		leftButton:Bool,
		shareButton:Bool,
		leftStickButton:Bool,
		trackPadButton:Bool,
		psButton:Bool,
		rightStickButton:Bool,
		optionsButton:Bool,
		triangleButton:Bool,
		circleButton:Bool,
		crossButton:Bool,
		squareButton:Bool,
		rightShoulderButton:Bool
		// right trigger digital reading
	) {

		self.leftShoulderButton = leftShoulderButton
		self.upButton = upButton
		self.rightButton = rightButton
		self.downButton = downButton
		self.leftButton = leftButton
		self.shareButton = shareButton
		self.leftStickButton = leftStickButton
		self.trackPadButton = trackPadButton
		self.psButton = psButton
		self.rightStickButton = rightStickButton
		self.optionsButton = optionsButton
		self.triangleButton = triangleButton
		self.circleButton = circleButton
		self.crossButton = crossButton
		self.squareButton = squareButton
		self.rightShoulderButton = rightShoulderButton

	}

}
