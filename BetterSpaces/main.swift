//
//  main.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 09/03/2022.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
