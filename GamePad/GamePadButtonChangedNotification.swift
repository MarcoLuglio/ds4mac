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

	/// for playstation and xbox, if the trigger is pressed or not
	/// for nintendo, the trigger is not analog anyway
	var leftTriggerButton = false

	var leftShoulderButton = false

	/// only nintendo
	var minusButton = false

	/// only nintendo switch, SL button on left joy-con
	var leftSideTopButton = false

	/// only nintendo switch, SR on left joy-con
	var leftSideBottomButton = false

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

	var trackPadButton = false

	/// ps button, xbox button, home button on nintendo
	var centralButton = false

	var rightStickButton = false
	var rightStickX:Float = 0
	var rightStickY:Float = 0

	/// options on playstation
	/// start on xbox 360
	/// hamburguer menu on xbox one and series x
	var rightAuxiliaryButton = false

	/// triangle, y on xbox, x on intendo
	var faceNorthButton = false

	/// circle button, b on xbox, a on nintendo
	var faceEastButton = false

	/// triangle, a on xbox, b on nintendo
	var faceSouthButton = false

	/// square, x on xbox, y on nintendo
	var faceWestButton = false

	/// only nintendo switch, SL on the right joy-con
	var rightSideBottomButton = false

	/// only nintendo switch, SR on the right joycon
	var rightSideTopButton = false

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
		leftSideTopButton:Bool,
		leftSideBottomButton:Bool,
		upButton:Bool,
		rightButton:Bool,
		downButton:Bool,
		leftButton:Bool,
		socialButton:Bool,
		leftStickButton:Bool,
		trackPadButton:Bool,
		centralButton:Bool,
		rightStickButton:Bool,
		rightAuxiliaryButton:Bool,
		faceNorthButton:Bool,
		faceEastButton:Bool,
		faceSouthButton:Bool,
		faceWestButton:Bool,
		rightSideBottomButton:Bool,
		rightSideTopButton:Bool,
		plusButton:Bool,
		rightShoulderButton:Bool,
		rightTriggerButton:Bool
	) {

		self.leftTriggerButton = leftTriggerButton
		self.leftShoulderButton = leftShoulderButton
		self.minusButton = minusButton
		self.leftSideTopButton = leftSideTopButton
		self.leftSideBottomButton = leftSideBottomButton
		self.upButton = upButton
		self.rightButton = rightButton
		self.downButton = downButton
		self.leftButton = leftButton
		self.socialButton = socialButton
		self.leftStickButton = leftStickButton
		self.trackPadButton = trackPadButton
		self.centralButton = centralButton
		self.rightStickButton = rightStickButton
		self.rightAuxiliaryButton = rightAuxiliaryButton
		self.faceNorthButton = faceNorthButton
		self.faceEastButton = faceEastButton
		self.faceSouthButton = faceSouthButton
		self.faceWestButton = faceWestButton
		self.rightSideBottomButton = rightSideBottomButton
		self.rightSideTopButton = rightSideTopButton
		self.plusButton = plusButton
		self.rightShoulderButton = rightShoulderButton
		self.rightTriggerButton = rightTriggerButton

	}

}
