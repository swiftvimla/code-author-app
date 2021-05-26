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

func openProjectSearch(close: @escaping () -> Void) -> NSWindow {
    let window = NSWindow(
        contentRect: NSRect(x: 0, y: 0, width: 800, height: 500),
        styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
        backing: .buffered, defer: false)
  let contentView = SearchProjects(close: { window.close() }, within: UserDefaults.vimlaURL).environmentObject(UserDefaults.model)
  window.contentView = NSHostingView(rootView: contentView)
    window.center()
    window.isReleasedWhenClosed = false // TODO: App crashes on second call to this function (not during the call but after) without this line, but ideally we _should_ release the window when it's closed.
    window.setFrameAutosaveName("Main Window")
    window.makeKeyAndOrderFront(nil)
    window.styleMask = .borderless
    
    return window
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow?
    var statusItem: NSStatusItem?

    let hotKey = HotKey(key: .e, modifiers: [.command, .shift])
    
    var searchWindow: NSWindow? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
      guard #available(macOS 11.0, *) else {
          fatalError("Upgrade to macOS 11")
      }
      
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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
      print(#function)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
      return false
    }
}

