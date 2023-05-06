//
//  Xbox360LedPattern.swift
//  GamePad
//
//  Created by Marco Luglio on 13/jun/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



enum Xbox360LedPattern:UInt8 {

	case reset  = 0x0E // untested, reset / disable everything?
	case allOff = 0x00
	case blink1 = 0x02
	case blink2 = 0x03
	case blink3 = 0x04
	case blink4 = 0x05
	case on1    = 0x06
	case on2    = 0x07
	case on3    = 0x08
	case on4    = 0x09
	case rotate = 0x0A // 1, then 2, then 3, then 4, then back to 1...

	// these return to previous states after they complete
	case allBlink = 0x01
	case blinkCurrent = 0x0B
	case blinkCurrentSlow = 0x0C
	case alternate = 0x0D // 1 and 3, then 2 and 4

}
