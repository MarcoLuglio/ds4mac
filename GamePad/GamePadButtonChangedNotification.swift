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

	let leftButton:Bool
	let rightButton:Bool

	init(
		leftButton:Bool,
		rightButton:Bool
	) {

		self.leftButton = leftButton
		self.rightButton = rightButton

	}

}
