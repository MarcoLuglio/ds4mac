//
//  AppDelegate.swift
//  GamePad
//
//  Created by Marco Luglio on 29/05/20.
//  Copyright © 2020 Marco Luglio. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!

	var gamePadHIDMonitor:GamepadHIDMonitor!

	var gamePadHIDThread:Thread!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

		// Create the window and set the content view. 
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false
		)

		/*
		window size is stored in UserDefaults
		override func awakeFromNib() {
		  super.awakeFromNib()

		  guard let data = UserDefaults.standard.data(forKey: key),
			let frame = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSRect else {
			  return
		  }

		  window?.setFrame(frame, display: true)
		}
		*/

		window.center()
		window.setFrameAutosaveName("DS4Mac")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)

		self.gamePadHIDMonitor = GamepadHIDMonitor()
		//self.gamePadHIDMonitor.hidapi()
		self.gamePadHIDThread = Thread(target: self.gamePadHIDMonitor, selector:#selector(self.gamePadHIDMonitor.setupHidObservers), object: nil)
		self.gamePadHIDThread.start()

		// TODO check where I can call this
		let cp = NSColorPanel.shared
		cp.setTarget(self)
		cp.setAction(#selector(self.colorDidChange))
		cp.makeKeyAndOrderFront(self)
		cp.isContinuous = true
	}

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

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

struct AppDelegate_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
