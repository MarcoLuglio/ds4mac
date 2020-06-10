//
//  ContentView.swift
//  GamePad
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import SwiftUI

struct Xbox360Tab: View {
    var body: some View {
        Text("View 1")
    }
}

struct DualShock4Tab: View {

	@ObservedObject var dualShock4:DualShock4UIModel = DualShock4UIModel()

    var body: some View {

        VStack {

			Group {
				Button(action: addItem) {
					if self.dualShock4.leftButton {
						Text("Pressed")
					} else {
						Text("Left button")
					}
				}
				Slider(value: $dualShock4.leftTrigger, in: 0...255, step: 1)
			}

			Group {
				Button("Up", action: addItem)
				Button("Right", action: addItem)
				Button("Down", action: addItem)
				Button("Left", action: addItem)
			}

			Button("Share", action: addItem)

			Text("Left stick")
			Text("Trackpad")
			Button("PS", action: addItem)
			Text("Right stick")

			Button("Options", action: addItem)

			Group {
				Button("Triangle", action: addItem)
				Button("Circle", action: addItem)
				Button("Cross", action: addItem)
				Button("Square", action: addItem)
			}

			Group {
				Button(action: addItem) {
					if self.dualShock4.leftButton {
						Text("Pressed")
					} else {
						Text("Right button")
					}
				}
				Slider(value: $dualShock4.rightTrigger, in: 0...255, step: 1)
			}

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
			Xbox360Tab()
				.tabItem {
					Text("Xbox 360")
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


func addItem() {
	//
}
