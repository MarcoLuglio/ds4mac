//
//  Xbox360ChangeLedNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 13/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class Xbox360ChangeLedNotification {

	static let Name = Notification.Name("Xbox360ChangeLedNotification")

	var ledPattern:Xbox360LedPattern

	init(ledPattern:Xbox360LedPattern) {
		self.ledPattern = ledPattern
	}

}
