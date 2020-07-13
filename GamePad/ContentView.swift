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

			Spacer()

			HStack {

				VStack {

					Button("Left heavy slow motor", action: rumbleLeft(intensity: 1))

					Button(action: addItem) {
						if self.dualShock4.leftShoulderButton {
							Text("Pressed")
						} else {
							Text("Left shoulder")
						}
					}

					Button(action: addItem) {
						if self.dualShock4.leftTriggerButton {
							Text("Pressed")
						} else {
							Text("Left trigger")
						}
					}
					Slider(value: $dualShock4.leftTrigger, in: 0...255, step: 1)

				}

				VStack {
					Button(action: addItem) {
						if self.dualShock4.upButton {
							Text("Pressed")
						} else {
							Text("Up")
						}
					}
					HStack {
						Button(action: addItem) {
							if self.dualShock4.rightButton {
								Text("Pressed")
							} else {
								Text("Right")
							}
						}
						Button(action: addItem) {
							if self.dualShock4.leftButton {
								Text("Pressed")
							} else {
								Text("Left")
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
				}

				VStack {

					Button(action: addItem) {
						if self.dualShock4.shareButton {
							Text("Pressed")
						} else {
							Text("Share")
						}
					}

					Button(action: addItem) {
						if self.dualShock4.leftStickButton {
							Text("Pressed")
						} else {
							Text("Left stick")
						}
					}

					Text("Left stick analog")
					Coords2d(x:CGFloat(self.dualShock4.leftStickX), y:CGFloat(self.dualShock4.leftStickY))

				}

				VStack {

					Button(action: addItem) {
						if self.dualShock4.trackPadButton {
							Text("Pressed")
						} else {
							Text("TrackPad")
						}
					}
					Text("Trackpad analog")

					Button(action: addItem) {
						if self.dualShock4.psButton {
							Text("Pressed")
						} else {
							Text("PS")
						}
					}

				}

				VStack {

					Button(action: addItem) {
						if self.dualShock4.optionsButton {
							Text("Pressed")
						} else {
							Text("Options")
						}
					}

					Button(action: addItem) {
						if self.dualShock4.rightStickButton {
							Text("Pressed")
						} else {
							Text("Right stick")
						}
					}

					Text("Right stick analog")
					Coords2d(x:CGFloat(self.dualShock4.rightStickX), y:CGFloat(self.dualShock4.rightStickY))

				}

				VStack {
					Button(action: addItem) {
						if self.dualShock4.triangleButton {
							Text("Pressed")
						} else {
							Text("Triangle")
						}
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
				}

				VStack {

					Button("Right light fast motor", action: rumbleRight(intensity: 1))

					Button(action: addItem) {
						if self.dualShock4.rightShoulderButton {
							Text("Pressed")
						} else {
							Text("Right shoulder")
						}
					}

					Button(action: addItem) {
						if self.dualShock4.rightTriggerButton {
							Text("Pressed")
						} else {
							Text("Right trigger")
						}
					}
					Slider(value: $dualShock4.rightTrigger, in: 0...255, step: 1)

				}

			}

			Slider<Text, Text>(
				value: $dualShock4.battery,
				in: 0...10,
				step: 1,
				onEditingChanged: {(someBool) in },
				minimumValueLabel: Text("0"),
				maximumValueLabel: Text("10"),
				label: {() in
					let batteryLevel = Int32(dualShock4.battery)
					let label = Text("battery level: \(batteryLevel)")
					return label
				}
			)

			Spacer()

		}

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

func rumbleLeft(intensity:UInt8) -> () -> Void {
	return {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: DualShock4ChangeRumbleNotification.Name,
				object: DualShock4ChangeRumbleNotification(
					leftHeavySlowRumble: intensity,
					rightLightFastRumble: 0
				)
			)
		}
	}
}

func rumbleRight(intensity:UInt8) -> () -> Void {
	return {
		DispatchQueue.main.async {
			NotificationCenter.default.post(
				name: DualShock4ChangeRumbleNotification.Name,
				object: DualShock4ChangeRumbleNotification(
					leftHeavySlowRumble: 0,
					rightLightFastRumble: intensity
				)
			)
		}
	}
}

func addItem() {
	//
}
