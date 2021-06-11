//
//  XboxSeriesXSTab.swift
//  GamePad
//
//  Created by Marco Luglio on 11/06/21.
//  Copyright © 2021 Marco Luglio. All rights reserved.
//

import SwiftUI



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
					var batteryState = xboxSeriesXS.isConnected ? "🔌" :"🔋"
					if xboxSeriesXS.isCharging {
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



struct XboxSeriesXSTab_Previews: PreviewProvider {
	static var previews: some View {
		XboxSeriesXSTab()
	}
}
