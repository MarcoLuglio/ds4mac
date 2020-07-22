//
//  ContentView.swift
//  GamePad
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import SwiftUI

struct XboxSeriesXTab: View {

    @ObservedObject var xboxSeriesX = XboxSeriesXUIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $xboxSeriesX.battery,
				in: 0...3,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("3"),
				label: {() in
					var batteryState = xboxSeriesX.isConnected ? "🔌" :"🔋"
					if xboxSeriesX.isCharging {
						batteryState += "⚡"
					}
					let label = Text("battery: \(batteryState)")
					return label
				}
			)
			.frame(
				minWidth: 150,
				idealWidth: 220,
				maxWidth: 250,
				minHeight: 30,
				idealHeight: 50,
				maxHeight: 80,
				alignment: Alignment.center
			)

			HStack {

				// MARK: Xbox left

				VStack {

					Button("Left trigger motor", action: rumbleLeft(intensity: 255))

					Slider(value: $xboxSeriesX.leftTrigger, in: 0...255, step: 1)
						.frame(
							minWidth: 100,
							idealWidth: 170,
							maxWidth: 200,
							minHeight: 30,
							idealHeight: 50,
							maxHeight: 80,
							alignment: Alignment.center
						)

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 30),
							cornerRadius: 30
						)
						.foregroundColor(self.xboxSeriesX.leftShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("LB").foregroundColor(Color.black)

					}

					Coords2d(
						x:CGFloat(self.xboxSeriesX.leftStickX),
						y:CGFloat(self.xboxSeriesX.leftStickY),
						foregroundColor: self.xboxSeriesX.leftStickButton ? Color.red : Color.white
					)
					.frame(
						minWidth: 100,
						idealWidth: 100,
						maxWidth: 100,
						minHeight: 100,
						idealHeight: 100,
						maxHeight: 100,
						alignment: Alignment(
							horizontal: HorizontalAlignment.center,
							vertical: VerticalAlignment.center
						)
					)
					.clipShape(Circle())

					Button(action: addItem) {
						if self.xboxSeriesX.upButton {
							Text("Pressed")
						} else {
							Text("Up")
						}
					}

					HStack {

						Button(action: addItem) {
							if self.xboxSeriesX.leftButton {
								Text("Pressed")
							} else {
								Text("Left")
							}
						}

						Button(action: addItem) {
							if self.xboxSeriesX.rightButton {
								Text("Pressed")
							} else {
								Text("Right")
							}
						}

					}

					Button(action: addItem) {
						if self.xboxSeriesX.downButton {
							Text("Pressed")
						} else {
							Text("Down")
						}
					}

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}

				// MARK: Xbox center

				Group {

					Button(action: addItem) {
						if self.xboxSeriesX.backButton {
							Text("Pressed")
						} else {
							Text("Back / View")
						}
					}

					Button(action: addItem) {
						if self.xboxSeriesX.xboxButton {
							Text("Pressed")
						} else {
							Text("Xbox")
						}
					}

					Button(action: addItem) {
						if self.xboxSeriesX.startButton {
							Text("Pressed")
						} else {
							Text("Start / Menu")
						}
					}

				}

				// MARK: Xbox right

				VStack {

					Button("Right trigger", action: rumbleRight(intensity: 1))

					Slider(value: $xboxSeriesX.rightTrigger, in: 0...255, step: 1)
						.frame(
							minWidth: 100,
							idealWidth: 170,
							maxWidth: 200,
							minHeight: 30,
							idealHeight: 50,
							maxHeight: 80,
							alignment: Alignment.center
						)

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 30),
							cornerRadius: 30
						)
						.foregroundColor(self.xboxSeriesX.rightShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("RB").foregroundColor(Color.black)

					}

					Button(action: addItem) {
						if self.xboxSeriesX.yButton {
							Text("Pressed")
						} else {
							Text("Y")
						}
					}

					HStack {

						Button(action: addItem) {
							if self.xboxSeriesX.xButton {
								Text("Pressed")
							} else {
								Text("X")
							}
						}

						Button(action: addItem) {
							if self.xboxSeriesX.bButton {
								Text("Pressed")
							} else {
								Text("B")
							}
						}

					}

					Button(action: addItem) {
						if self.xboxSeriesX.aButton {
							Text("Pressed")
						} else {
							Text("A")
						}
					}

					Coords2d(
						x:CGFloat(self.xboxSeriesX.rightStickX),
						y:CGFloat(self.xboxSeriesX.rightStickY),
						foregroundColor: self.xboxSeriesX.rightStickButton ? Color.red : Color.white
					)
					.frame(
						minWidth: 100,
						idealWidth: 100,
						maxWidth: 100,
						minHeight: 100,
						idealHeight: 100,
						maxHeight: 100,
						alignment: Alignment(
							horizontal: HorizontalAlignment.center,
							vertical: VerticalAlignment.center
						)
					)
					.clipShape(Circle())

					Button("Right light fast motor", action: rumbleRight(intensity: 1))

				}

			}

		}

	}

}

struct DualShock4Tab: View {

	@ObservedObject var dualShock4 = DualShock4UIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $dualShock4.battery,
				in: 0...10,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("10"),
				label: {() in
					var batteryState = dualShock4.isConnected ? "🔌" :"🔋"
					if dualShock4.isCharging {
						batteryState += "⚡"
					}
					let label = Text("battery: \(batteryState)")
					return label
				}
			)
			.frame(
				minWidth: 150,
				idealWidth: 220,
				maxWidth: 250,
				minHeight: 30,
				idealHeight: 50,
				maxHeight: 80,
				alignment: Alignment.center
			)

			HStack {

				// MARK: DualShock4 left

				VStack {

					Slider(value: $dualShock4.leftTrigger, in: 0...255, step: 1)
						.frame(
							minWidth: 100,
							idealWidth: 170,
							maxWidth: 200,
							minHeight: 30,
							idealHeight: 50,
							maxHeight: 80,
							alignment: Alignment.center
						)

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: -0.5)
						.foregroundColor(self.dualShock4.leftShoulderButton ? Color.red : Color.white)
						.clipped()
						.frame(
							minWidth: 70,
							idealWidth: 70,
							maxWidth: 70,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("L1").foregroundColor(Color.black)

					}

					Button(action: addItem) {
						if self.dualShock4.upButton {
							Text("Pressed")
						} else {
							Text("Up")
						}
					}

					HStack {

						Button(action: addItem) {
							if self.dualShock4.leftButton {
								Text("Pressed")
							} else {
								Text("Left")
							}
						}

						Button(action: addItem) {
							if self.dualShock4.rightButton {
								Text("Pressed")
							} else {
								Text("Right")
							}
						}

					}

					Button(action: addItem) {
						if self.dualShock4.downButton {
							Text("Pressed")
						} else {
							Text("Down")
						}
					}

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}


				// MARK: DualShock4 center

				VStack {

					HStack {

						VStack {

							Text("SHARE").font(Font.system(size: 9))

							if self.dualShock4.shareButton {
								Path(
									roundedRect: CGRect(x: 0, y: 0, width: 15, height: 30),
									cornerRadius: 8
								)
								.foregroundColor(Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
								.frame(
									minWidth: 15,
									idealWidth: 15,
									maxWidth: 15,
									minHeight: 30,
									idealHeight: 30,
									maxHeight: 30,
									alignment: Alignment.top
								)
							} else {
								Path(
									roundedRect: CGRect(x: 0, y: 0, width: 15, height: 30),
									cornerRadius: 8
								)
								.foregroundColor(Color.init(Color.RGBColorSpace.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
								.frame(
									minWidth: 15,
									idealWidth: 15,
									maxWidth: 15,
									minHeight: 30,
									idealHeight: 30,
									maxHeight: 30,
									alignment: Alignment.top
								)
							}
						}

						VStack {

							Path(roundedRect: CGRect(x:0, y:0, width:160, height:30), cornerRadius: 15)
								.foregroundColor(Color.init(
									Color.RGBColorSpace.sRGB,
									red: dualShock4.red,
									green: dualShock4.green,
									blue: dualShock4.blue,
									opacity: 1
								))
								.frame(
									minWidth: 160,
									idealWidth: 160,
									maxWidth: 160,
									minHeight: 30,
									idealHeight: 30,
									maxHeight: 30,
									alignment: Alignment.center
								)

							ZStack {

								Coords2d(
									x:CGFloat(self.dualShock4.touchpadTouch0X),
									y:CGFloat(self.dualShock4.touchpadTouch0Y),
									foregroundColor: self.dualShock4.trackPadButton ? Color.red : Color.white
								)
								.frame(
									minWidth: 260,
									idealWidth: 260,
									maxWidth: 300,
									minHeight: 80,
									idealHeight: 100,
									maxHeight: 120,
									alignment: Alignment(
										horizontal: HorizontalAlignment.center,
										vertical: VerticalAlignment.center
									)
								)

								Coords2d(
									x:CGFloat(self.dualShock4.touchpadTouch1X),
									y:CGFloat(self.dualShock4.touchpadTouch1Y),
									foregroundColor: Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 1, blue: 1, opacity: 0) // transparent
								)
								.frame(
									minWidth: 260,
									idealWidth: 260,
									maxWidth: 300,
									minHeight: 80,
									idealHeight: 100,
									maxHeight: 120,
									alignment: Alignment(
										horizontal: HorizontalAlignment.center,
										vertical: VerticalAlignment.center
									)
								)

							}

						}

						VStack {

							Text("OPTIONS").font(Font.system(size: 9))

							if self.dualShock4.optionsButton {
								Path(
									roundedRect: CGRect(x: 0, y: 0, width: 15, height: 30),
									cornerRadius: 8
								)
								.foregroundColor(Color.init(Color.RGBColorSpace.sRGB, red: 1, green: 0, blue: 0, opacity: 1))
								.frame(
									minWidth: 15,
									idealWidth: 15,
									maxWidth: 15,
									minHeight: 30,
									idealHeight: 30,
									maxHeight: 30,
									alignment: Alignment.top
								)
							} else {
								Path(
									roundedRect: CGRect(x: 0, y: 0, width: 15, height: 30),
									cornerRadius: 8
								)
								.foregroundColor(Color.init(Color.RGBColorSpace.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 1))
								.frame(
									minWidth: 15,
									idealWidth: 15,
									maxWidth: 15,
									minHeight: 30,
									idealHeight: 30,
									maxHeight: 30,
									alignment: Alignment.top
								)
							}

						}

					}

					HStack {

						Coords2d(
							x:CGFloat(self.dualShock4.leftStickX),
							y:CGFloat(self.dualShock4.leftStickY),
							foregroundColor: self.dualShock4.leftStickButton ? Color.red : Color.white
						)
						.frame(
							minWidth: 100,
							idealWidth: 100,
							maxWidth: 100,
							minHeight: 100,
							idealHeight: 100,
							maxHeight: 100,
							alignment: Alignment(
								horizontal: HorizontalAlignment.center,
								vertical: VerticalAlignment.center
							)
						)
						.clipShape(Circle())
						/*.overlay(
							Circle().stroke(Color.gray, lineWidth: 4))*/

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 22, height: 22),
							cornerRadius: 11
						)
						.foregroundColor(self.dualShock4.psButton ? Color.red : Color.white)
						.frame(
							minWidth: 22,
							idealWidth: 22,
							maxWidth: 22,
							minHeight: 22,
							idealHeight: 22,
							maxHeight: 22,
							alignment: Alignment.center
						)

						Coords2d(
							x:CGFloat(self.dualShock4.rightStickX),
							y:CGFloat(self.dualShock4.rightStickY),
							foregroundColor: self.dualShock4.rightStickButton ? Color.red : Color.white
						)
						.frame(
							minWidth: 100,
							idealWidth: 100,
							maxWidth: 100,
							minHeight: 100,
							idealHeight: 100,
							maxHeight: 100,
							alignment: Alignment(
								horizontal: HorizontalAlignment.center,
								vertical: VerticalAlignment.center
							)
						)
						.clipShape(Circle())
						/*.overlay(
							Circle().stroke(Color.gray, lineWidth: 4))*/

					}

				}

				// MARK: DualShock4 right

				VStack {

					Slider(value: $dualShock4.rightTrigger, in: 0...255, step: 1)
						.frame(
							minWidth: 100,
							idealWidth: 170,
							maxWidth: 200,
							minHeight: 30,
							idealHeight: 50,
							maxHeight: 80,
							alignment: Alignment.center
						)

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: -0.5)
						.foregroundColor(self.dualShock4.rightShoulderButton ? Color.red : Color.white)
						.clipped()
						.frame(
							minWidth: 70,
							idealWidth: 70,
							maxWidth: 70,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("R1").foregroundColor(Color.black)

					}

					if self.dualShock4.triangleButton {
						Text("Pressed")
					} else {
						Text("Triangle")
					}

					HStack {

						Button(action: addItem) {
							if self.dualShock4.squareButton {
								Text("Pressed")
							} else {
								Text("Square")
							}
						}

						Button(action: addItem) {
							if self.dualShock4.circleButton {
								Text("Pressed")
							} else {
								Text("Circle")
							}
						}

					}

					Button(action: addItem) {
						if self.dualShock4.crossButton {
							Text("Pressed")
						} else {
							Text("Cross")
						}
					}

					Button("Right light fast motor", action: rumbleRight(intensity: 255))

				}

			}
			.scaledToFit()

			HStack {

				VStack {
					Text("Gyro pitch: \(self.dualShock4.gyroPitch)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:  \(self.dualShock4.gyroYaw)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.dualShock4.gyroRoll)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

				VStack {
					Text("Accel x:  \(self.dualShock4.accelX)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.dualShock4.accelY)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.dualShock4.accelZ)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

		}
		.scaledToFit()

	}

}

struct JoyConTab: View {

	@ObservedObject var joyCon = JoyConUIModel()

	var body: some View {

		HStack {

			// MARK: JoyCon left
			VStack {

				Slider<Text, Text>(
					value: $joyCon.batteryLeft,
					in: 0...3,
					step: 1,
					onEditingChanged: {(someBool) in },
					minimumValueLabel: Text("0"),
					maximumValueLabel: Text("3"),
					label: {() in
						var batteryState = joyCon.isConnected ? "🔌" :"🔋"
						if joyCon.isCharging {
							batteryState += "⚡"
						}
						let label = Text("battery: \(batteryState)")
						return label
					}
				)
				.frame(
					minWidth: 150,
					idealWidth: 220,
					maxWidth: 250,
					minHeight: 30,
					idealHeight: 50,
					maxHeight: 80,
					alignment: Alignment.center
				)

				Group {

					//Button("Left motor", action: rumbleLeft(intensity: 1))

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: 0.5)
						.foregroundColor(self.joyCon.leftTriggerButton ? Color.red : Color.white)
						.clipped()
						.frame(
							minWidth: 70,
							idealWidth: 70,
							maxWidth: 70,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("ZL").foregroundColor(Color.black)

					}

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 15),
							cornerRadius: 15
						)
						.foregroundColor(self.joyCon.leftShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 15,
							idealHeight: 15,
							maxHeight: 15,
							alignment: Alignment.center
						)

						Text("L").foregroundColor(Color.black)

					}

					Button(action: addItem) {
						if self.joyCon.minusButton {
							Text("Pressed")
						} else {
							Text("-")
						}
					}

				}

				HStack {

					Coords2d(
						x:CGFloat(self.joyCon.leftStickX),
						y:CGFloat(self.joyCon.leftStickY),
						foregroundColor: self.joyCon.leftStickButton ? Color.red : Color.white
					)
					.frame(
						minWidth: 100,
						idealWidth: 100,
						maxWidth: 100,
						minHeight: 100,
						idealHeight: 100,
						maxHeight: 100,
						alignment: Alignment(
							horizontal: HorizontalAlignment.center,
							vertical: VerticalAlignment.center
						)
					)
					.clipShape(Circle())

					ZStack {

						Path(CGRect(x: 0, y: 0, width: 15, height: 30))
							.foregroundColor(self.joyCon.leftSideTopButton ? Color.red : Color.white)
							.frame(
								minWidth: 15,
								idealWidth: 15,
								maxWidth: 15,
								minHeight: 30,
								idealHeight: 30,
								maxHeight: 30,
								alignment: Alignment.center
							)

						Text("SL")
							.foregroundColor(Color.black)
							.rotationEffect(Angle(degrees: 90))

					}

				}

				VStack {

					Button(action: addItem) {
						if self.joyCon.upButton {
							Text("Pressed")
						} else {
							Text("Up")
						}
					}

					HStack {

						Button(action: addItem) {
							if self.joyCon.leftButton {
								Text("Pressed")
							} else {
								Text("Left")
							}
						}

						Button(action: addItem) {
							if self.joyCon.rightButton {
								Text("Pressed")
							} else {
								Text("Right")
							}
						}

					}

					Button(action: addItem) {
						if self.joyCon.downButton {
							Text("Pressed")
						} else {
							Text("Down")
						}
					}

				}

				HStack {

					Button(action: addItem) {
						if self.joyCon.captureButton {
							Text("Pressed")
						} else {
							Text("Capture")
						}
					}

					ZStack {

						Path(CGRect(x: 0, y: 0, width: 15, height: 30))
							.foregroundColor(self.joyCon.leftSideBottomButton ? Color.red : Color.white)
							.frame(
								minWidth: 15,
								idealWidth: 15,
								maxWidth: 15,
								minHeight: 30,
								idealHeight: 30,
								maxHeight: 30,
								alignment: Alignment.center
							)

						Text("SR")
							.foregroundColor(Color.black)
							.rotationEffect(Angle(degrees: 90))

					}

				}

				VStack {
					Text("Gyro pitch: \(self.joyCon.gyroPitchLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:  \(self.joyCon.gyroYawLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.joyCon.gyroRollLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel x:  \(self.joyCon.accelXLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.joyCon.accelYLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.joyCon.accelZLeft)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

			// MARK: JoyCon right
			VStack{

				Slider<Text, Text>(
					value: $joyCon.batteryRight,
					in: 0...3,
					step: 1,
					onEditingChanged: {(someBool) in },
					minimumValueLabel: Text("0"),
					maximumValueLabel: Text("3"),
					label: {() in
						var batteryState = joyCon.isConnected ? "🔌" :"🔋"
						if joyCon.isCharging {
							batteryState += "⚡"
						}
						let label = Text("battery: \(batteryState)")
						return label
					}
				)
				.frame(
					minWidth: 150,
					idealWidth: 220,
					maxWidth: 250,
					minHeight: 30,
					idealHeight: 50,
					maxHeight: 80,
					alignment: Alignment.center
				)

				Group {

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: 0.5)
							.foregroundColor(self.joyCon.rightTriggerButton ? Color.red : Color.white)
						.clipped()
						.frame(
							minWidth: 70,
							idealWidth: 70,
							maxWidth: 70,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("ZR").foregroundColor(Color.black)

					}

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 15),
							cornerRadius: 15
						)
						.foregroundColor(self.joyCon.rightShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 15,
							idealHeight: 15,
							maxHeight: 15,
							alignment: Alignment.center
						)

						Text("R").foregroundColor(Color.black)

					}

					Button(action: addItem) {
						if self.joyCon.plusButton {
							Text("Pressed")
						} else {
							Text("+")
						}
					}

					//Button("Right light fast motor", action: rumbleRight(intensity: 1))

				}

				HStack {

					ZStack {

						Path(CGRect(x: 0, y: 0, width: 15, height: 30))
							.foregroundColor(self.joyCon.rightSideTopButton ? Color.red : Color.white)
							.frame(
								minWidth: 15,
								idealWidth: 15,
								maxWidth: 15,
								minHeight: 30,
								idealHeight: 30,
								maxHeight: 30,
								alignment: Alignment.center
							)

						Text("SR")
							.foregroundColor(Color.black)
							.rotationEffect(Angle(degrees: -90))

					}

					VStack {

						Button(action: addItem) {
							if self.joyCon.xButton {
								Text("Pressed")
							} else {
								Text("X")
							}
						}

						HStack {

							Button(action: addItem) {
								if self.joyCon.yButton {
									Text("Pressed")
								} else {
									Text("Y")
								}
							}

							Button(action: addItem) {
								if self.joyCon.aButton {
									Text("Pressed")
								} else {
									Text("A")
								}
							}

						}

						Button(action: addItem) {
							if self.joyCon.bButton {
								Text("Pressed")
							} else {
								Text("B")
							}
						}

					}

				}

				Coords2d(
					x:CGFloat(self.joyCon.rightStickX),
					y:CGFloat(self.joyCon.rightStickY),
					foregroundColor: self.joyCon.rightStickButton ? Color.red : Color.white
				)
				.frame(
					minWidth: 100,
					idealWidth: 100,
					maxWidth: 100,
					minHeight: 100,
					idealHeight: 100,
					maxHeight: 100,
					alignment: Alignment(
						horizontal: HorizontalAlignment.center,
						vertical: VerticalAlignment.center
					)
				)
				.clipShape(Circle())

				HStack {

					ZStack {

						Path(CGRect(x: 0, y: 0, width: 15, height: 30))
							.foregroundColor(self.joyCon.rightSideBottomButton ? Color.red : Color.white)
							.frame(
								minWidth: 15,
								idealWidth: 15,
								maxWidth: 15,
								minHeight: 30,
								idealHeight: 30,
								maxHeight: 30,
								alignment: Alignment.center
							)

						Text("SL")
							.foregroundColor(Color.black)
							.rotationEffect(Angle(degrees: -90))

					}

					Button(action: addItem) {
						if self.joyCon.homeButton {
							Text("Pressed")
						} else {
							Text("Home")
						}
					}

				}

				VStack {
					Text("Gyro pitch: \(self.joyCon.gyroPitchRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:  \(self.joyCon.gyroYawRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.joyCon.gyroRollRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel x:  \(self.joyCon.accelXRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.joyCon.accelYRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.joyCon.accelZRight)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

		}

	}

}

struct ContentView: View {

	var body: some View {

		TabView {
			// TODO do a for each here
			JoyConTab()
				.tabItem {
					Text("Joy-Con")
				}
			XboxSeriesXTab()
				.tabItem {
					Text("Xbox")
				}
			DualShock4Tab()
				.tabItem {
					Text("DualShock 4")
				}
		}

	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

var previousLeftRumbleIntensity:UInt8 = 0

func rumbleLeft(intensity:UInt8) -> () -> Void {
	return {

		var newIntensity = intensity

		if previousLeftRumbleIntensity != 0 {
			newIntensity = 0
		}

		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: DualShock4ChangeRumbleNotification.Name,
				object: DualShock4ChangeRumbleNotification(
					leftHeavySlowRumble: newIntensity,
					rightLightFastRumble: 0
				)
			)
		}

		previousLeftRumbleIntensity = newIntensity

	}
}

var previousRightRumbleIntensity:UInt8 = 0

func rumbleRight(intensity:UInt8) -> () -> Void {
	return {

		var newIntensity = intensity

		if previousRightRumbleIntensity != 0 {
			newIntensity = 0
		}

		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: DualShock4ChangeRumbleNotification.Name,
				object: DualShock4ChangeRumbleNotification(
					leftHeavySlowRumble: 0,
					rightLightFastRumble: newIntensity
				)
			)
		}

		previousRightRumbleIntensity = newIntensity
	}
}

func addItem() {
	//
}
