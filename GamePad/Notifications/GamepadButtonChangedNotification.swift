//
//  GamePadButtonChangedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 01/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class GamepadButtonChangedNotification {

	static let Name = Notification.Name("GamePadButtonChangedNotification")

	/// for playstation and xbox, if the trigger is pressed or not
	/// for nintendo, the trigger is not analog anyway
	var leftTriggerButton = false

	var leftShoulderButton = false

	/// only nintendo
	var minusButton = false

	/// left back paddle on playstation edge
	/// left top back paddle on xbox elite
	/// SL button on nintendo left joy-con
	var backLeftTopButton = false

	/// left function button on playstation edge
	/// left bottom back paddle on xbox elite
	/// SR button on nintendo left joy-con
	var backLeftBottomButton = false

	// directional pad buttons
	var upButton = false
	var rightButton = false
	var downButton = false
	var leftButton = false

	/// share/create button on playstation
	/// back button on xbox 360
	/// upload button on xbox series x
	/// capture button on nintendo switch
	var socialButton = false

	/// windows button on xbox one and series x
	var windowsButton = false // FIXME this is not being sent in the notification

	var leftStickButton = false
	var leftStickX:Float = 0
	var leftStickY:Float = 0

	/// ps button, xbox button, home button on nintendo
	var centralButton = false

	var trackPadButton = false

	var rightStickButton = false
	var rightStickX:Float = 0
	var rightStickY:Float = 0

	// FIXME where do I put the xbox one and series x view button?
	// var leftAuxiliaryButton = false

	/// options on playstation
	/// start on xbox 360
	/// hamburguer menu on xbox one and series x
	/// home button on nintendo switch
	var rightAuxiliaryButton = false

	/// triangle, y on xbox, x on nintendo
	var faceNorthButton = false

	/// circle button, b on xbox, a on nintendo
	var faceEastButton = false

	/// triangle, a on xbox, b on nintendo
	var faceSouthButton = false

	/// square, x on xbox, y on nintendo
	var faceWestButton = false

	/// right function button on playstation edge
	/// right bottom back paddle on xbox elite
	/// SL button on nintendo left joy-con
	var backRightBottomButton = false

	/// right back paddle on playstation edge
	/// right top back paddle on xbox elite
	/// SR button on nintendo right joycon
	var backRightTopButton = false

	/// only nintendo
	var plusButton = false

	var rightShoulderButton = false

	/// for playstation and xbox, if the trigger is pressed or not
	/// for nintendo, the trigger is not analog anyway
	var rightTriggerButton = false

	init(
		leftTriggerButton:Bool,
		leftShoulderButton:Bool,
		minusButton:Bool,
		backLeftTopButton:Bool,
		backLeftBottomButton:Bool,
		upButton:Bool,
		rightButton:Bool,
		downButton:Bool,
		leftButton:Bool,
		socialButton:Bool,
		leftStickButton:Bool,
		centralButton:Bool,
		trackPadButton:Bool,
		rightStickButton:Bool,
		rightAuxiliaryButton:Bool,
		faceNorthButton:Bool,
		faceEastButton:Bool,
		faceSouthButton:Bool,
		faceWestButton:Bool,
		backRightBottomButton:Bool,
		backRightTopButton:Bool,
		plusButton:Bool,
		rightShoulderButton:Bool,
		rightTriggerButton:Bool
	) {

		self.leftTriggerButton = leftTriggerButton
		self.leftShoulderButton = leftShoulderButton
		self.minusButton = minusButton
		self.backLeftTopButton = backLeftTopButton
		self.backLeftBottomButton = backLeftBottomButton
		self.upButton = upButton
		self.rightButton = rightButton
		self.downButton = downButton
		self.leftButton = leftButton
		self.socialButton = socialButton
		self.leftStickButton = leftStickButton
		self.centralButton = centralButton
		self.trackPadButton = trackPadButton
		self.rightStickButton = rightStickButton
		self.rightAuxiliaryButton = rightAuxiliaryButton
		self.faceNorthButton = faceNorthButton
		self.faceEastButton = faceEastButton
		self.faceSouthButton = faceSouthButton
		self.faceWestButton = faceWestButton
		self.backRightBottomButton = backRightBottomButton
		self.backRightTopButton = backRightTopButton
		self.plusButton = plusButton
		self.rightShoulderButton = rightShoulderButton
		self.rightTriggerButton = rightTriggerButton

	}

}
