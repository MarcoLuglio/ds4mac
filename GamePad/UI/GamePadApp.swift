//
//  GamePadApp.swift
//  GamePad
//
//  Created by Marco Luglio on 11/jun/21.
//

import SwiftUI



@main
struct GamePadApp: App {

	// https://www.hackingwithswift.com/quick-start/swiftui/how-to-add-an-appdelegate-to-a-swiftui-app
	// @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	var gamePadHIDMonitor:GamepadHIDMonitor!

	var gamePadHIDThread:Thread!

	init() {

		self.gamePadHIDMonitor = GamepadHIDMonitor()
		//self.gamePadHIDMonitor.hidapi()
		self.gamePadHIDThread = Thread(target: self.gamePadHIDMonitor!, selector:#selector(self.gamePadHIDMonitor.setupHidObservers), object: nil)
		self.gamePadHIDThread.start()

		// TODO check where I can call this
		/*
		let cp = NSColorPanel.shared
		cp.setTarget(self)
		cp.setAction(#selector(self.colorDidChange))
		cp.makeKeyAndOrderFront(self)
		cp.isContinuous = true
		*/

	}


	/*
	// @objc can only be used in classes and @objc protocols, not structs
	@objc func colorDidChange(sender:Any) {

		if let cp = sender as? NSColorPanel {

			DispatchQueue.main.async {
				NotificationCenter.default.post(
					name: DualShock4ChangeLedNotification.Name,
					object: DualShock4ChangeLedNotification(
						red: cp.color.redComponent,
						green: cp.color.greenComponent,
						blue: cp.color.blueComponent
					)
				)
			}

			//self.window.backgroundColor = cp.color

		}

	}
	*/

	var body: some Scene {
		WindowGroup {
			ContentView()
		}
	}

}
