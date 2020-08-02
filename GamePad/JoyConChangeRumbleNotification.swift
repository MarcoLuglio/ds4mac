//
//  DualShock4ChangeRumbleNotification.swift
//  GamePad
//
//  Created by Marco Luglio on 12/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



final class JoyConChangeRumbleNotification {

	static let Name = Notification.Name("JoyConChangeRumbleNotification")

	let leftHighBand:UInt16
	let leftLowBand:UInt16
	let rightHighBand:UInt16
	let rightLowBand:UInt16

	// TODO amplitude an time as well?
	init(leftHighBand:UInt16, leftLowBand:UInt16, rightHighBand:UInt16, rightLowBand:UInt16) {

		self.leftHighBand = leftHighBand
		self.leftLowBand = leftLowBand
		self.rightHighBand = rightHighBand
		self.rightLowBand = rightLowBand

		// rumble left
		// buffer[2] rumble
		// buffer[3] rumble
		// buffer[4] rumble
		// buffer[5] rumble

		// rumble right
		// buffer[6] rumble
		// buffer[7] rumble
		// buffer[8] rumble
		// buffer[9] rumble

		/*
		Rumble data

		Iterator byte
		then 4 bytes of rumble data for left Joy-Con,
		followed by 4 bytes for right Joy-Con.
		[00 01 40 40     00 01 40 40] (320Hz 0.0f 160Hz 0.0f) is neutral.

		The rumble data structure contains
		2 bytes High Band data,
		2 bytes Low Band data.
		The values for HF Band frequency and LF amplitude are encoded.

		Byte#    Range                                  Remarks
		0,   4   x04 - xFC (81.75Hz - 313.14Hz)         High Band Lower Frequency. Steps +0x0004.
		0-1, 4-5 x00 01 - xFC 01 (320.00Hz - 1252.57Hz) Byte 1,5 LSB enables High Band Higher Frequency. Steps +0x0400.
		1,   5   x00 00 - xC8 00 (0.0f - 1.0f)          High Band Amplitude. Steps +0x0200. Real max: FE.
		2,   6   x01 - x7F (40.87Hz - 626.28Hz)         Low Band Frequency.
		3,   7   x40 - x72 (0.0f - 1.0f)                Low Band Amplitude. Safe max: 00 72.
		2-3, 6-7 x80 40 - x80 71 (0.01f - 0.98f)        Byte 2,6 +0x80 enables intermediate LF amplitude. Real max: 80 FF.

		For a rumble values table, example and the algorithm for frequency, check rumble_data_table.md.
		The byte values for frequency raise the frequency in Hz exponentially and not linearly.
		Don't use real maximum values for Amplitude. Otherwise, they can damage the linear actuators. These safe amplitude ranges are defined by Switch HID library.
		*/


	}

}
