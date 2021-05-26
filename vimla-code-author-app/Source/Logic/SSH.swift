//
//  SSH.swift
//  vimla-code-author-app
//
//  Created by Jonatan Sundqvist on 2020-08-25.
//  Copyright © 2020 Jonatan Sundqvist. All rights reserved.
//

import Foundation

func ssh() {
    let task = Process()
    task.launchPath = "/usr/bin/ssh"
    task.arguments = [
        "-F",
        "$DEVOPS_HOME/settings/workstation/ssh-config",
        "-o",
        "UserKnownHostsFile=$DEVOPS_HOME/settings/workstation/known_hosts",
        "-o",
        "StrictHostKeyChecking=yes",
        "-o",
        "GlobalKnownHostsFile=/dev/null"
    ]
    task.launch()
}
