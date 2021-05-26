//
//  Configure.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2020-08-25.
//  Copyright © 2020 Jonatan Sundqvist. All rights reserved.
//

import Foundation

struct UserDefaults {
    static let terminalURL: URL = URL(fileURLWithPath: "/Applications/iTerm.app")
    static let editorURL: URL = URL(fileURLWithPath: "/Applications/Visual Studio Code.app")
    static let gitURL: URL = URL(fileURLWithPath: "/usr/bin/git")
    static let vimlaURL: URL = URL(fileURLWithPath: "/Users/jonatan/vimla/repositories")
    static let model = Model()
}
