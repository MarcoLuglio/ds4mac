//
//  ContentView.swift
//  GamePad
//
//  Created by Marco Luglio on 29/may/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import SwiftUI



struct XboxEliteSeries2Tab: View {

	@ObservedObject var xboxEliteSeries = XboxEliteSeries2UIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $xboxEliteSeries.battery,
				in: 0...3,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("3"),
				label: {() in
					var batteryState = self.xboxEliteSeries.isConnected ? "🔌" :"🔋"
					if self.xboxEliteSeries.isCharging {
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

					Slider(value: $xboxEliteSeries.leftTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.xboxEliteSeries.leftShoulderButton ? Color.red : Color.white)
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
						x:CGFloat(self.xboxEliteSeries.leftStickX),
						y:CGFloat(self.xboxEliteSeries.leftStickY),
						foregroundColor: self.xboxEliteSeries.leftStickButton ? Color.red : Color.white
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

					if self.xboxEliteSeries.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.xboxEliteSeries.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.xboxEliteSeries.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.xboxEliteSeries.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}

				// MARK: Xbox center

				Group {

					if self.xboxEliteSeries.backButton {
						Text("Pressed")
					} else {
						Text("Back / View")
					}

					if self.xboxEliteSeries.xboxButton {
						Text("Pressed")
					} else {
						Text("Xbox")
					}

					if self.xboxEliteSeries.startButton {
						Text("Pressed")
					} else {
						Text("Start / Menu")
					}

				}

				// MARK: Xbox right

				VStack {

					Button("Right trigger motor", action: rumbleRight(intensity: 1))

					Slider(value: $xboxEliteSeries.rightTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.xboxEliteSeries.rightShoulderButton ? Color.red : Color.white)
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

					if self.xboxEliteSeries.yButton {
						Text("Pressed")
					} else {
						Text("Y")
					}

					HStack {

						if self.xboxEliteSeries.xButton {
							Text("Pressed")
						} else {
							Text("X")
						}

						if self.xboxEliteSeries.bButton {
							Text("Pressed")
						} else {
							Text("B")
						}

					}

					if self.xboxEliteSeries.aButton {
						Text("Pressed")
					} else {
						Text("A")
					}

					Coords2d(
						x:CGFloat(self.xboxEliteSeries.rightStickX),
						y:CGFloat(self.xboxEliteSeries.rightStickY),
						foregroundColor: self.xboxEliteSeries.rightStickButton ? Color.red : Color.white
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

struct XboxSeriesXSTab: View {

	@ObservedObject var xboxSeriesXS = XboxSeriesXSUIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $xboxSeriesXS.battery,
				in: 0...3,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("3"),
				label: {() in
					var batteryState = self.xboxSeriesXS.isConnected ? "🔌" :"🔋"
					if self.xboxSeriesXS.isCharging {
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

					Slider(value: $xboxSeriesXS.leftTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.xboxSeriesXS.leftShoulderButton ? Color.red : Color.white)
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
						x:CGFloat(self.xboxSeriesXS.leftStickX),
						y:CGFloat(self.xboxSeriesXS.leftStickY),
						foregroundColor: self.xboxSeriesXS.leftStickButton ? Color.red : Color.white
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

					if self.xboxSeriesXS.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.xboxSeriesXS.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.xboxSeriesXS.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.xboxSeriesXS.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}

				// MARK: Xbox center

				Group {

					if self.xboxSeriesXS.backButton {
						Text("Pressed")
					} else {
						Text("Back / View")
					}

					if self.xboxSeriesXS.xboxButton {
						Text("Pressed")
					} else {
						Text("Xbox")
					}

					if self.xboxSeriesXS.startButton {
						Text("Pressed")
					} else {
						Text("Start / Menu")
					}

				}

				// MARK: Xbox right

				VStack {

					Button("Right trigger motor", action: rumbleRight(intensity: 1))

					Slider(value: $xboxSeriesXS.rightTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.xboxSeriesXS.rightShoulderButton ? Color.red : Color.white)
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

					if self.xboxSeriesXS.yButton {
						Text("Pressed")
					} else {
						Text("Y")
					}

					HStack {

						if self.xboxSeriesXS.xButton {
							Text("Pressed")
						} else {
							Text("X")
						}

						if self.xboxSeriesXS.bButton {
							Text("Pressed")
						} else {
							Text("B")
						}

					}

					if self.xboxSeriesXS.aButton {
						Text("Pressed")
					} else {
						Text("A")
					}

					Coords2d(
						x:CGFloat(self.xboxSeriesXS.rightStickX),
						y:CGFloat(self.xboxSeriesXS.rightStickY),
						foregroundColor: self.xboxSeriesXS.rightStickButton ? Color.red : Color.white
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

struct DualSenseTab: View {

	@ObservedObject var dualSenseEdge = DualSenseUIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $dualSenseEdge.battery,
				in: 0...10,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("10"),
				label: {() in
					var batteryState = dualSenseEdge.isConnected ? "🔌" :"🔋"
					if dualSenseEdge.isCharging {
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

				// MARK: DualSense Edge left

				VStack {

					Slider(value: $dualSenseEdge.leftTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.dualSenseEdge.leftShoulderButton ? Color.red : Color.white)
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

					if self.dualSenseEdge.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.dualSenseEdge.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.dualSenseEdge.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.dualSenseEdge.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}


				// MARK: DualSense Edge center

				VStack {

					HStack {

						VStack {

							Text("SHARE").font(Font.system(size: 9))

							if self.dualSenseEdge.shareButton {
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
									red: dualSenseEdge.red,
									green: dualSenseEdge.green,
									blue: dualSenseEdge.blue,
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
									x:CGFloat(self.dualSenseEdge.touchpadTouch0X),
									y:CGFloat(self.dualSenseEdge.touchpadTouch0Y),
									foregroundColor: self.dualSenseEdge.trackPadButton ? Color.red : Color.white
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
									x:CGFloat(self.dualSenseEdge.touchpadTouch1X),
									y:CGFloat(self.dualSenseEdge.touchpadTouch1Y),
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

							if self.dualSenseEdge.optionsButton {
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

						VStack {

							Coords2d(
								x:CGFloat(self.dualSenseEdge.leftStickX),
								y:CGFloat(self.dualSenseEdge.leftStickY),
								foregroundColor: self.dualSenseEdge.leftStickButton ? Color.red : Color.white
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

							if self.dualSenseEdge.leftFnButton {
								Text("Pressed")
							} else {
								Text("Fn")
							}

							if self.dualSenseEdge.leftPaddle {
								Text("Pressed")
							} else {
								Text("Paddle")
							}

						}

						VStack {

							Path(
								roundedRect: CGRect(x: 0, y: 0, width: 22, height: 22),
								cornerRadius: 11
							)
							.foregroundColor(self.dualSenseEdge.psButton ? Color.red : Color.white)
							.frame(
								minWidth: 22,
								idealWidth: 22,
								maxWidth: 22,
								minHeight: 22,
								idealHeight: 22,
								maxHeight: 22,
								alignment: Alignment.center
							)

							if self.dualSenseEdge.muteButton {
								Text("Pressed")
							} else {
								Text("Mute")
							}

						}

						VStack {

							Coords2d(
								x:CGFloat(self.dualSenseEdge.rightStickX),
								y:CGFloat(self.dualSenseEdge.rightStickY),
								foregroundColor: self.dualSenseEdge.rightStickButton ? Color.red : Color.white
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

							if self.dualSenseEdge.rightFnButton {
								Text("Pressed")
							} else {
								Text("Fn")
							}

							if self.dualSenseEdge.rightPaddle {
								Text("Pressed")
							} else {
								Text("Paddle")
							}

						}

					}

				}

				// MARK: DualSense Edge right

				VStack {

					Slider(value: $dualSenseEdge.rightTrigger, in: 0...255, step: 1)
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
						.foregroundColor(self.dualSenseEdge.rightShoulderButton ? Color.red : Color.white)
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

					if self.dualSenseEdge.triangleButton {
						Text("Pressed")
					} else {
						Text("Triangle")
					}

					HStack {

						if self.dualSenseEdge.squareButton {
							Text("Pressed")
						} else {
							Text("Square")
						}

						if self.dualSenseEdge.circleButton {
							Text("Pressed")
						} else {
							Text("Circle")
						}

					}

					if self.dualSenseEdge.crossButton {
						Text("Pressed")
					} else {
						Text("Cross")
					}

					Button("Right light fast motor", action: rumbleRight(intensity: 255))

				}

			}
			.scaledToFit()

			HStack {

				VStack {
					Text("Gyro pitch: \(self.dualSenseEdge.gyroPitch)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:   \(self.dualSenseEdge.gyroYaw)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.dualSenseEdge.gyroRoll)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

				VStack {
					Text("Accel x:  \(self.dualSenseEdge.accelX)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.dualSenseEdge.accelY)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.dualSenseEdge.accelZ)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

		}
		.scaledToFit()

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

					if self.dualShock4.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.dualShock4.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.dualShock4.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.dualShock4.downButton {
						Text("Pressed")
					} else {
						Text("Down")
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

						if self.dualShock4.squareButton {
							Text("Pressed")
						} else {
							Text("Square")
						}

						if self.dualShock4.circleButton {
							Text("Pressed")
						} else {
							Text("Circle")
						}

					}

					if self.dualShock4.crossButton {
						Text("Pressed")
					} else {
						Text("Cross")
					}

					Button("Right light fast motor", action: rumbleRight(intensity: 255))

				}

			}
			.scaledToFit()

			HStack {

				VStack {
					Text("Gyro pitch: \(self.dualShock4.gyroPitch)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:   \(self.dualShock4.gyroYaw)").frame(width: 150, height: 30, alignment: Alignment.leading)
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

struct NintendoProTab: View {

	@ObservedObject var nintendoPro = NintendoProUIModel()

	var body: some View {

		VStack {

			Slider<Text, Text>(
				value: $nintendoPro.battery,
				in: 0...3,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("3"),
				label: {() in
					var batteryState = self.nintendoPro.isConnected ? "🔌" :"🔋"
					if self.nintendoPro.isCharging {
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

				// MARK: Nintendo Pro left

				VStack {

					// Button("Left trigger motor", action: rumbleLeft(intensity: 255))

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: 0.5)
						.foregroundColor(self.nintendoPro.leftTriggerButton ? Color.red : Color.white)
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
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 30),
							cornerRadius: 30
						)
						.foregroundColor(self.nintendoPro.leftShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("L").foregroundColor(Color.black)

					}

					Coords2d(
						x:CGFloat(self.nintendoPro.leftStickX),
						y:CGFloat(self.nintendoPro.leftStickY),
						foregroundColor: self.nintendoPro.leftStickButton ? Color.red : Color.white
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

					if self.nintendoPro.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.nintendoPro.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.nintendoPro.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.nintendoPro.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}

					// Button("Left heavy slow motor", action: rumbleLeft(intensity: 255))

				}

				// MARK: Nintendo Pro center

				Group {

					if self.nintendoPro.minusButton {
						Text("Pressed")
					} else {
						Text("-")
					}

					if self.nintendoPro.captureButton {
						Text("Pressed")
					} else {
						Text("Capture")
					}

					if self.nintendoPro.homeButton {
						Text("Pressed")
					} else {
						Text("Home")
					}

					if self.nintendoPro.plusButton {
						Text("Pressed")
					} else {
						Text("+")
					}

				}

				// MARK: Nintendo Pro right

				VStack {

					// Button("Right trigger", action: rumbleRight(intensity: 1))

					ZStack {

						Path(
							roundedRect: CGRect(x: 0, y: 0, width: 70, height: 60),
							cornerRadius: 30
						)
						.offsetBy(dx: 0, dy: 0.5)
							.foregroundColor(self.nintendoPro.rightTriggerButton ? Color.red : Color.white)
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
							roundedRect: CGRect(x: 0, y: 0, width: 90, height: 30),
							cornerRadius: 30
						)
						.foregroundColor(self.nintendoPro.rightShoulderButton ? Color.red : Color.white)
						.frame(
							minWidth: 90,
							idealWidth: 90,
							maxWidth: 90,
							minHeight: 30,
							idealHeight: 30,
							maxHeight: 30,
							alignment: Alignment.center
						)

						Text("R").foregroundColor(Color.black)

					}

					if self.nintendoPro.xButton {
						Text("Pressed")
					} else {
						Text("X")
					}

					HStack {

						if self.nintendoPro.yButton {
							Text("Pressed")
						} else {
							Text("Y")
						}

						if self.nintendoPro.aButton {
							Text("Pressed")
						} else {
							Text("A")
						}

					}

					if self.nintendoPro.bButton {
						Text("Pressed")
					} else {
						Text("B")
					}

					Coords2d(
						x:CGFloat(self.nintendoPro.rightStickX),
						y:CGFloat(self.nintendoPro.rightStickY),
						foregroundColor: self.nintendoPro.rightStickButton ? Color.red : Color.white
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

					// Button("Right light fast motor", action: rumbleRight(intensity: 1))

				}

			}

		}

	}

}

struct JoyConTab: View {

	@ObservedObject var joyCon = JoyConUIModel()

	var body: some View {

		HStack {

			// MARK: JoyCon left
			VStack {

				Slider<Text, Text>(
					value: $joyCon.leftBattery,
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

					if self.joyCon.minusButton {
						Text("Pressed")
					} else {
						Text("-")
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

					if self.joyCon.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}

					HStack {

						if self.joyCon.leftButton {
							Text("Pressed")
						} else {
							Text("Left")
						}

						if self.joyCon.rightButton {
							Text("Pressed")
						} else {
							Text("Right")
						}

					}

					if self.joyCon.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}

				}

				HStack {

					if self.joyCon.captureButton {
						Text("Pressed")
					} else {
						Text("Capture")
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
					Text("Gyro pitch: \(self.joyCon.leftGyroPitch)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:  \(self.joyCon.leftGyroYaw)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.joyCon.leftGyroRoll)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel x:  \(self.joyCon.leftAccelX)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.joyCon.leftAccelY)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.joyCon.leftAccelZ)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

			// MARK: JoyCon right
			VStack{

				Slider<Text, Text>(
					value: $joyCon.leftBattery,
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

					if self.joyCon.plusButton {
						Text("Pressed")
					} else {
						Text("+")
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

						if self.joyCon.xButton {
							Text("Pressed")
						} else {
							Text("X")
						}

						HStack {

							if self.joyCon.yButton {
								Text("Pressed")
							} else {
								Text("Y")
							}

							if self.joyCon.aButton {
								Text("Pressed")
							} else {
								Text("A")
							}

						}

						if self.joyCon.bButton {
							Text("Pressed")
						} else {
							Text("B")
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

					if self.joyCon.homeButton {
						Text("Pressed")
					} else {
						Text("Home")
					}

				}

				VStack {
					Text("Gyro pitch: \(self.joyCon.rightGyroPitch)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro yaw:   \(self.joyCon.rightGyroYaw)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Gyro roll:  \(self.joyCon.rightGyroRoll)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel x:  \(self.joyCon.rightAccelX)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel y:  \(self.joyCon.rightAccelY)").frame(width: 150, height: 30, alignment: Alignment.leading)
					Text("Accel z:  \(self.joyCon.rightAccelZ)").frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

		}

	}

}

struct ContentView: View {

	var body: some View {

		TabView {
			// TODO do a for each here
			DualSenseTab()
				.tabItem {
					Text("DualSense Edge")
				}
			NintendoProTab()
				.tabItem {
					Text("Nintendo Switch Pro")
				}
			JoyConTab()
				.tabItem {
					Text("Joy-Con")
				}
			XboxEliteSeries2Tab()
				.tabItem {
					Text("Xbox Elite Series 2")
				}
			XboxSeriesXSTab()
				.tabItem {
					Text("Xbox Series XS")
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
