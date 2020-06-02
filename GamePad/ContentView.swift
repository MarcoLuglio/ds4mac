//
//  ContentView.swift
//  GamePad
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	//@Model var a:Bool

	var body: some View {
		Text("Hello, World!")
			.frame(maxWidth: .infinity, maxHeight: .infinity)
	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

/*
NotificationCenter.addObserver(
	self,
	selector: #selector(userLoggedIn),
	name: Notification.Name("UserLoggedIn"),
	object: nil
)
*/
