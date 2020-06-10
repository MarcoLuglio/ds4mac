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

	var leftButton:Bool = false  {
	   willSet {
		   objectWillChange.send()
	   }
   }
	var leftTrigger:Float = 0

	var rightButton:Bool = false
	var rightTrigger:Float = 0

	let objectWillChange = ObservableObjectPublisher()

	init() {

		NotificationCenter.default
			.addObserver(
				self,
				selector: #selector(self.updateButtons),
				name: DualShock4Controller.NOTIFICATION_NAME_BUTTONS, // TODO put the names in a separate class
				object: nil
			)

	}

	@objc func updateButtons(_ notification:Notification) {

		let o = notification.object as! GamePadButtonChangedNotification

		self.leftButton = o.leftButton
		self.rightButton = o.rightButton

	}

}
