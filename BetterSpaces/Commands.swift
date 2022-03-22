//
//  Commands.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation

struct Commands {
    static let GetCurrentSpace = "/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index'"
    
    static let GetAppWindowId = "/usr/local/bin/yabai -m query --windows | /usr/local/bin/jq '.[] | select(.app==\"\(Config.appName)\") | .id'"
    
    static let GetCurrentWindowId = "/usr/local/bin/yabai -m query --windows --window | /usr/local/bin/jq .id"
    
    static var BringSwitcherToFront: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        let index = Shell.execute(Commands.GetCurrentSpace)
        return "/usr/local/bin/yabai -m window \(id) --space \(index); /usr/local/bin/yabai -m window \(id) --focus"
    }
    
    static var MoveLeft: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        if id.isEmpty {
            return "/usr/local/bin/yabai -m space --focus prev"
        } else {
            return "/usr/local/bin/yabai -m window \(id) --space prev; /usr/local/bin/yabai -m space --focus prev; /usr/local/bin/yabai -m window \(id) --focus"
        }
    }
    
    static var MoveRight: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        if id.isEmpty {
            return "/usr/local/bin/yabai -m space --focus next"
        } else {
            return "/usr/local/bin/yabai -m window \(id) --space next; /usr/local/bin/yabai -m space --focus next; /usr/local/bin/yabai -m window \(id) --focus"
        }
    }
    
    static var MoveUp: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index - Config.row
        if id.isEmpty {
            return "/usr/local/bin/yabai -m space --focus \(targetSpace)"
        } else {
            return "/usr/local/bin/yabai -m window \(id) --space \(targetSpace); /usr/local/bin/yabai -m space --focus \(targetSpace); /usr/local/bin/yabai -m window \(id) --focus"
        }
    }
    
    static var MoveDown: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index + Config.row
        if id.isEmpty {
            return "/usr/local/bin/yabai -m space --focus \(targetSpace)"
        } else {
            return "/usr/local/bin/yabai -m window \(id) --space \(targetSpace); /usr/local/bin/yabai -m space --focus \(targetSpace); /usr/local/bin/yabai -m window \(id) --focus"
        }
    }
    
    static func MoveWindowLeft(windowId: String) -> String {
        return "/usr/local/bin/yabai -m window \(windowId) --space prev; /usr/local/bin/yabai -m space --focus prev; /usr/local/bin/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowRight(windowId: String) -> String {
        return "/usr/local/bin/yabai -m window \(windowId) --space next; /usr/local/bin/yabai -m space --focus next; /usr/local/bin/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowUp(windowId: String) -> String {
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index - Config.row
        return "/usr/local/bin/yabai -m window \(windowId) --space \(targetSpace); /usr/local/bin/yabai -m space --focus \(targetSpace); /usr/local/bin/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowDown(windowId: String) -> String {
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index + Config.row
        return "/usr/local/bin/yabai -m window \(windowId) --space \(targetSpace); /usr/local/bin/yabai -m space --focus \(targetSpace); /usr/local/bin/yabai -m window \(windowId) --focus"
    }
}
