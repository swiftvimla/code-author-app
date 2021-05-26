//
//  Core.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2020-08-25.
//  Copyright © 2020 Jonatan Sundqvist. All rights reserved.
//

import Foundation
import AppKit

func openProject(at url: URL) {
    guard let application = try? NSWorkspace.shared.open([url], withApplicationAt: UserDefaults.editorURL, options: [.async], configuration: [:]) else {
        print("Failed to open project at \(url.absoluteString)")
        return
    }
    print(application)
}

func openTerminal(at url: URL) {
    guard let application = try? NSWorkspace.shared.open([url], withApplicationAt: UserDefaults.terminalURL, options: [.async], configuration: [:]) else {
        print("Failed to open terminal at \(url.absoluteString)")
        return
    }
    print(application)
}
