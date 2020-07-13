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

			Group {
				Button("Left heavy slow motor", action: rumbleLeft(intensity: 1))
				Slider(value: $xboxSeriesX.leftTrigger, in: 0...255, step: 1)
				Button(action: addItem) {
					if self.xboxSeriesX.leftTriggerButton {
						Text("Pressed")
					} else {
						Text("Left trigger")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.leftShoulderButton {
						Text("Pressed")
					} else {
						Text("Left shoulder")
					}
				}
			}

			Group {
				Button(action: addItem) {
					if self.xboxSeriesX.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.rightButton {
						Text("Pressed")
					} else {
						Text("Right")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.leftButton {
						Text("Pressed")
					} else {
						Text("Left")
					}
				}
			}

			Group {

				Button(action: addItem) {
					if self.xboxSeriesX.backButton {
						Text("Pressed")
					} else {
						Text("Back")
					}
				}

				Button(action: addItem) {
					if self.xboxSeriesX.leftStickButton {
						Text("Pressed")
					} else {
						Text("Left stick")
					}
				}
				Text("Left stick analog")

			}

			Button(action: addItem) {
				if self.xboxSeriesX.xboxButton {
					Text("Pressed")
				} else {
					Text("Xbox")
				}
			}

			Group {

				Text("Right stick analog")
				Button(action: addItem) {
					if self.xboxSeriesX.rightStickButton {
						Text("Pressed")
					} else {
						Text("Right stick")
					}
				}

				Button(action: addItem) {
					if self.xboxSeriesX.startButton {
						Text("Pressed")
					} else {
						Text("Start")
					}
				}

			}

			Group {
				Button(action: addItem) {
					if self.xboxSeriesX.yButton {
						Text("Pressed")
					} else {
						Text("Y")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.bButton {
						Text("Pressed")
					} else {
						Text("B")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.aButton {
						Text("Pressed")
					} else {
						Text("A")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.xButton {
						Text("Pressed")
					} else {
						Text("X")
					}
				}
			}

			Group {
				Button(action: addItem) {
					if self.xboxSeriesX.rightShoulderButton {
						Text("Pressed")
					} else {
						Text("Right shoulder")
					}
				}
				Button(action: addItem) {
					if self.xboxSeriesX.rightTriggerButton {
						Text("Pressed")
					} else {
						Text("Right trigger")
					}
				}
				Slider(value: $xboxSeriesX.rightTrigger, in: 0...255, step: 1)
				Button("Right light fast motor", action: rumbleRight(intensity: 1))
			}

		}

	}

}

struct DualShock4Tab: View {

	@ObservedObject var dualShock4 = DualShock4UIModel()

	var body: some View {

		VStack {

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

					if self.dualShock4.leftShoulderButton {
						ZStack {
							Path(
								roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
								cornerRadius: 30
							)
							.offsetBy(dx: 0, dy: -0.5)
							.foregroundColor(Color.red)
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
					} else {
						ZStack {
							Path(
								roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
								cornerRadius: 30
							)
							.offsetBy(dx: 0, dy: -0.5)
							.foregroundColor(Color.white)
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

							Coords2d(
								x:CGFloat(self.dualShock4.leftStickX),
								y:CGFloat(self.dualShock4.leftStickY),
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

						VStack {

							// TODO get the trackpad touches
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

						}

						if self.dualShock4.psButton {
							Path(
								roundedRect: CGRect(x: 0, y: 0, width: 22, height: 22),
								cornerRadius: 11
							)
							.foregroundColor(Color.red)
							.frame(
								minWidth: 22,
								idealWidth: 22,
								maxWidth: 22,
								minHeight: 22,
								idealHeight: 22,
								maxHeight: 22,
								alignment: Alignment.center
							)
						} else {
							Path(
								roundedRect: CGRect(x: 0, y: 0, width: 22, height: 22),
								cornerRadius: 11
							)
							.foregroundColor(Color.white)
							.frame(
								minWidth: 22,
								idealWidth: 22,
								maxWidth: 22,
								minHeight: 22,
								idealHeight: 22,
								maxHeight: 22,
								alignment: Alignment.center
							)
						}

						VStack {

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

					if self.dualShock4.rightShoulderButton {
						ZStack {
							Path(
								roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
								cornerRadius: 30
							)
							.offsetBy(dx: 0, dy: -0.5)
							.foregroundColor(Color.red)
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
					} else {
						ZStack {
							Path(
								roundedRect: CGRect(x: 0, y: -30, width: 70, height: 60),
								cornerRadius: 30
							)
							.offsetBy(dx: 0, dy: -0.5)
							.foregroundColor(Color.white)
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

		}
		.scaledToFit()

	}

}

struct JoyConTab: View {

	@ObservedObject var joyCon = JoyConUIModel()

	var body: some View {

		VStack {

			Group {
				//Button("Left motor", action: rumbleLeft(intensity: 1))
				Button(action: addItem) {
					if self.joyCon.leftTriggerButton {
						Text("Pressed")
					} else {
						Text("Left trigger")
					}
				}
				Button(action: addItem) {
					if self.joyCon.leftShoulderButton {
						Text("Pressed")
					} else {
						Text("Left shoulder")
					}
				}
				Button(action: addItem) {
					if self.joyCon.minusButton {
						Text("Pressed")
					} else {
						Text("-")
					}
				}
			}

			Group {

				Button(action: addItem) {
					if self.joyCon.leftStickButton {
						Text("Pressed")
					} else {
						Text("Left stick")
					}
				}
				Text("Left stick analog")
				Button(action: addItem) {
					if self.joyCon.leftSideTopButton {
						Text("Pressed")
					} else {
						Text("Left side top")
					}
				}

			}

			Group {
				Button(action: addItem) {
					if self.joyCon.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}
				}
				Button(action: addItem) {
					if self.joyCon.rightButton {
						Text("Pressed")
					} else {
						Text("Right")
					}
				}
				Button(action: addItem) {
					if self.joyCon.downButton {
						Text("Pressed")
					} else {
						Text("Down")
					}
				}
				Button(action: addItem) {
					if self.joyCon.leftButton {
						Text("Pressed")
					} else {
						Text("Left")
					}
				}
			}

			Group {

				Button(action: addItem) {
					if self.joyCon.captureButton {
						Text("Pressed")
					} else {
						Text("Capture")
					}
				}

				Button(action: addItem) {
					if self.joyCon.leftSideBottomButton {
						Text("Pressed")
					} else {
						Text("Left side bottom")
					}
				}

				Button(action: addItem) {
					if self.joyCon.rightSideBottomButton {
						Text("Pressed")
					} else {
						Text("Right side bottom")
					}
				}

				Button(action: addItem) {
					if self.joyCon.homeButton {
						Text("Pressed")
					} else {
						Text("Home")
					}
				}

			}

			Group {

				Text("Right stick analog")
				Button(action: addItem) {
					if self.joyCon.rightStickButton {
						Text("Pressed")
					} else {
						Text("Right stick")
					}
				}

			}

			Group {
				Button(action: addItem) {
					if self.joyCon.xButton {
						Text("Pressed")
					} else {
						Text("X")
					}
				}
				Button(action: addItem) {
					if self.joyCon.aButton {
						Text("Pressed")
					} else {
						Text("A")
					}
				}
				Button(action: addItem) {
					if self.joyCon.bButton {
						Text("Pressed")
					} else {
						Text("B")
					}
				}
				Button(action: addItem) {
					if self.joyCon.yButton {
						Text("Pressed")
					} else {
						Text("Y")
					}
				}
			}

			Group {
				Button(action: addItem) {
					if self.joyCon.plusButton {
						Text("Pressed")
					} else {
						Text("+")
					}
				}
				Button(action: addItem) {
					if self.joyCon.rightShoulderButton {
						Text("Pressed")
					} else {
						Text("Right shoulder")
					}
				}
				Button(action: addItem) {
					if self.joyCon.rightTriggerButton {
						Text("Pressed")
					} else {
						Text("Right trigger")
					}
				}
				//Button("Right light fast motor", action: rumbleRight(intensity: 1))
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
			DualShock4Tab()
				.tabItem {
					Text("DualShock 4")
				}
			XboxSeriesXTab()
				.tabItem {
					Text("Xbox")
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
