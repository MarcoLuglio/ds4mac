//
//  ContentView.swift
//  GamePad
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import SwiftUI



struct ContentView: View {

	var body: some View {

		TabView {
			// TODO do a for each here
			DualShock4Tab()
				.tabItem {
					Text("DualShock 4")
				}
			JoyConTab()
				.tabItem {
					Text("Joy-Con")
				}
			XboxSeriesXSTab()
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
