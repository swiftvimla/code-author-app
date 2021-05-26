//
//  Git.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2020-08-25.
//  Copyright © 2020 Jonatan Sundqvist. All rights reserved.
//

import Foundation

struct Git {
    struct Status {}
    
    enum Command: String {
        case branch
    }
    
    static func run(command: Git.Command, in directory: URL) -> String? {
        let git = Process()
        git.executableURL = UserDefaults.gitURL
        git.arguments = ["-C", String(directory.absoluteString.dropFirst("file://".count)), command.rawValue]
        
        let stdout = Pipe()
        git.standardOutput = stdout
        git.standardError = Pipe()
        git.standardError = Pipe()
        
        guard let _ = try? git.run() else {
            print("Failed to run git command")
            return nil
        }
        
        let outputData = stdout.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)
        return output
    }
}
