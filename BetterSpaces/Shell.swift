//
//  Shell.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation

struct Shell {
    static func execute(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.launchPath = "/usr/bin/env"
        task.arguments = ["bash", "-c", command]
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
        
        return output
    }
}
