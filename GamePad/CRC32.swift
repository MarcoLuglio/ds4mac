//
//  CRC32.swift
//  GamePad
//
//  Created by Marco Luglio on 31/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Foundation



class CRC32 {

	static var table:[UInt32] = {
		(0...255).map { i -> UInt32 in
			(0..<8).reduce(UInt32(i), { c, _ in
				(c % 2 == 0) ? (c >> 1) : (0x4C11DB7 ^ (c >> 1)) //  is this were I put the polinomial?
			})
		}
	}()

	static func checksum(bytes:[UInt8]) -> [UInt8] {

		let crc32Int = ~(bytes.reduce(~UInt32(0), { crc, byte in
			(crc >> 8) ^ table[(Int(crc) ^ Int(byte)) & 0xFF]
		}))

		var crc32ByteArray = [UInt8](repeating: 0, count: 4)

		for i in 0...3 {
			crc32ByteArray[i] = UInt8(0x0000FF & crc32Int >> UInt32((3 - i) * 8))
		}

		return crc32ByteArray

	}

}
