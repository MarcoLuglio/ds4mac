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

			Group {
				Button("Left heavy slow motor", action: rumbleLeft(intensity: 1))
				Slider(value: $dualShock4.leftTrigger, in: 0...255, step: 1)
				Button(action: addItem) {
					if self.dualShock4.leftTriggerButton {
						Text("Pressed")
					} else {
						Text("Left trigger")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.leftShoulderButton {
						Text("Pressed")
					} else {
						Text("Left shoulder")
					}
				}
			}

			Group {
				Button(action: addItem) {
					if self.dualShock4.upButton {
						Text("Pressed")
					} else {
						Text("Up")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.rightButton {
						Text("Pressed")
					} else {
						Text("Right")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.downButton {
						Text("Pressed")
					} else {
						Text("Down")
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

			Group {

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

			}

			Group {

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

			Group {

				Text("Right stick analog")
				Button(action: addItem) {
					if self.dualShock4.rightStickButton {
						Text("Pressed")
					} else {
						Text("Right stick")
					}
				}

				Button(action: addItem) {
					if self.dualShock4.optionsButton {
						Text("Pressed")
					} else {
						Text("Options")
					}
				}

			}

			Group {
				Button(action: addItem) {
					if self.dualShock4.triangleButton {
						Text("Pressed")
					} else {
						Text("Triangle")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.circleButton {
						Text("Pressed")
					} else {
						Text("Circle")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.crossButton {
						Text("Pressed")
					} else {
						Text("Cross")
					}
				}
				Button(action: addItem) {
					if self.dualShock4.squareButton {
						Text("Pressed")
					} else {
						Text("Square")
					}
				}
			}

			Group {
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
				Button("Right light fast motor", action: rumbleRight(intensity: 1))
			}

			Group {
				Slider(value: $dualShock4.battery, in: 0...8, step: 1)
			}

			/*Slider(
				value: $dualShock4.battery,
				in: 0...8,
				step: 1,
				onEditingChanged: editingChanged,
				minimumValueLabel: "0",
				maximumValueLabel: "100%",
				label: "Battery"
			)*/

		}

	}

}

struct JoyConTab: View {
    var body: some View {
        Text("View 2")
    }
}

struct ContentView: View {

	var body: some View {

		TabView {
			// TODO do a for each here
			XboxSeriesXTab()
				.tabItem {
					Text("Xbox")
				}
			DualShock4Tab()
				.tabItem {
					Text("DualShock 4")
				}
			JoyConTab()
				.tabItem {
					Text("Joy-Con")
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
