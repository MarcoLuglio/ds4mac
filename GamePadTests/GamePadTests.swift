//
//  GamePadTests.swift
//  GamePadTests
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import XCTest
@testable import GamePad



class GamePadTests: XCTestCase {

	/*
	pitchPlus 157
	pitchMinus 165
	yawPlus 102
	yawMinus 94
	rollPlus 91
	rollMinus 143
	accelXPlus 87
	accelXMinus 169
	accelYPlus 218
	accelYMinus 38
	accelZPlus 207
	accelZMinus 49
	*/

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testAccelCalibration() throws {
		let calibrated = DualShock4Controller.applyAccelCalibration(32000, sensorRawPositive1GValue:87, sensorRawNegative1GValue:169)
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	func testGyroCalibration() throws {
		let calibrated = DualShock4Controller.applyGyroCalibration(<#T##sensorRawValue: Int32##Int32#>, <#T##sensorBias: Int32##Int32#>, <#T##gyroSpeed2x: Int32##Int32#>, sensorRange: <#T##Int32#>)
		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	/*
	func testPerformanceExample() throws {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	*/

}
