//
//  JoyConDirection.swift
//  GamePad
//
//  Created by Marco Luglio on 20/06/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



/*
Both joy-cons have the same mapping when it comes to the thumbstick
when the are used as separate mini controllers on the horizontal position

When using on the vertical position, we would need to rotate these values accordingly
But I'll leave them all pre mapped here
*/

enum JoyConLeftDirection:UInt8 {

	case right     = 0x00
	case rightDown = 0x01
	case down      = 0x02
	case leftDown  = 0x03
	case left      = 0x04
	case leftUp    = 0x05
	case up        = 0x06
	case rightUp   = 0x07

}

enum JoyConRightDirection:UInt8 {

	case left     = 0x00
	case leftUp = 0x01
	case up      = 0x02
	case rightUp  = 0x03
	case right      = 0x04
	case rightDown    = 0x05
	case down        = 0x06
	case leftDown   = 0x07

}

/// When the joy-cons are used separately by each player, in an horizontal orientation
enum JoyConSplitDirection:UInt8 {

	case up     = 0x00
	case rightUp = 0x01
	case right      = 0x02
	case rightDown  = 0x03
	case down      = 0x04
	case leftDown    = 0x05
	case left        = 0x06
	case leftUp   = 0x07

}
