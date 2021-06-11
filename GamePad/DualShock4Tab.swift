//
//  DualShock4Tab.swift
//  GamePad
//
//  Created by Marco Luglio on 11/06/21.
//  Copyright © 2021 Marco Luglio. All rights reserved.
//

import SwiftUI



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
					Text(String(format: "Accel x: %.2f", self.dualShock4.accelX)).frame(width: 150, height: 30, alignment: Alignment.leading)
					Text(String(format: "Accel y: %.2f", self.dualShock4.accelY)).frame(width: 150, height: 30, alignment: Alignment.leading)
					Text(String(format: "Accel z: %.2f", self.dualShock4.accelZ)).frame(width: 150, height: 30, alignment: Alignment.leading)
				}

			}

		}
		.scaledToFit()

	}

}



struct DualShock4Tab_Previews: PreviewProvider {
	static var previews: some View {
		DualShock4Tab()
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
