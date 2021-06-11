//
//  JoyConTab.swift
//  GamePad
//
//  Created by Marco Luglio on 11/06/21.
//  Copyright © 2021 Marco Luglio. All rights reserved.
//

import SwiftUI



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



struct JoyConTab_Previews: PreviewProvider {
	static var previews: some View {
		JoyConTab()
	}
}

