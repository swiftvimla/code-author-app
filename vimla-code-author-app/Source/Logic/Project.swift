//
//  Project.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2020-08-25.
//  Copyright © 2020 Jonatan Sundqvist. All rights reserved.
//

import Foundation

struct Project {
    let root: URL
    let label: String
    let activeBranch: String?
    let remoteUrl: URL?
}

extension Project: Identifiable, Hashable {
    var id: String { self.root.absoluteString }
}

func loadProjects(from directory: URL) -> [Project]? {
    guard let folders = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [], options: .producesRelativePathURLs) else {
        return nil
    }
    return folders.map { url in
        let nl: Character = "\n"
        let activeBranch = Git.run(command: .branch, in: url)?.split(separator: nl).first(where: { $0.hasPrefix("*") }).map { String($0.dropFirst(2)) }
        return Project(
            root: url,
            label: url.lastPathComponent,
            activeBranch: activeBranch,
            remoteUrl: URL(string: "")
        )
    }
}
