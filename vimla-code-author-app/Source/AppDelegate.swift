//
//  AppDelegate.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2019-10-18.
//  Copyright © 2019 Jonatan Sundqvist. All rights reserved.
//

import Cocoa
import SwiftUI
import HotKey
import UserNotifications

func openProjectSearch(close: @escaping () -> Void) -> NSWindow {
  let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 800, height: 500),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered, defer: false)
  let contentView = SearchProjects(close: { window.close() }, within: UserDefaults.vimlaURL).environmentObject(UserDefaults.model)
  window.contentView = NSHostingView(rootView: contentView)
  window.center()
  window.isReleasedWhenClosed = false // TODO: App crashes on second call to this function (not during the call but after) without this line, but ideally we _should_ release the window when it's closed.
  window.setFrameAutosaveName("Search Projects - Vimla Code Author")
  window.makeKeyAndOrderFront(nil)
  window.styleMask = .borderless
  NSApplication.shared.activate(ignoringOtherApps: true) // This places the window on top of all other windows so that we can see it immediately.

  return window
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  var window: NSWindow?
  var statusItem: NSStatusItem?

  let hotKey = HotKey(key: .e, modifiers: [.command, .shift])
  
  var searchWindow: NSWindow? = nil
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Sandbox
    
    // Create the SwiftUI view that provides the window contents.
    let contentView = ContentView()
  
    // Create the window and set the content view.
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
    window.center()
    window.setFrameAutosaveName("Main Window")
    window.contentView = NSHostingView(rootView: contentView)
    window.makeKeyAndOrderFront(nil)
    self.window = window

    NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusItem.button?.title = "􀙤"
    let menu = NSMenu()
    statusItem.menu = menu
    self.statusItem = statusItem

    hotKey.keyDownHandler = {
      print("Running hotkey handler")
      statusItem.button?.title = "\(Int.random(in: 0 ... 10))"
      if self.searchWindow != nil {
        self.searchWindow?.close()
        print("Done closing previous")
      }
      print("Gonna create new")
      self.searchWindow = openProjectSearch(close: {})
      print("Done creating new")
    }
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
          // Handle the error here.
      }
      
      // Enable or disable features based on the authorization.
    }
    
    let content = UNMutableNotificationContent()
    content.title = "Good morning, developer!"
    content.body = "Brew some coffee and get on with it."
    content.badge = 5
  
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.autoupdatingCurrent
    dateComponents.weekday = dateComponents.day
    dateComponents.hour = 23
    dateComponents.minute = 59
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let uuidString = UUID().uuidString
    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { error in
      if error != nil {
        print(error)
      }
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
    print(#function)
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }
}

