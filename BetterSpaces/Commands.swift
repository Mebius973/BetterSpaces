//
//  Commands.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation

struct Commands {
    static var BinPath: String {
        #if (arch(i386) || arch(x86_64))
        return "/usr/local/bin"
        #else
        return "/opt/homebrew/bin"
        #endif
    }
    
    static let GetCurrentSpace = "\(BinPath)/yabai -m query --spaces --space | \(BinPath)/jq '.index'"
    
    static let GetAppWindowId = "\(BinPath)/yabai -m query --windows | \(BinPath)/jq '.[] | select(.app==\"\(Config.appName)\") | .id'"
    
    static let GetCurrentWindowId = "\(BinPath)/yabai -m query --windows --window | \(BinPath)/jq .id"
    
    static let GetTopWindowId = "\(BinPath)/yabai -m query --windows --space | \(BinPath)/jq 'map(select(.app!=\"\(Config.appName)\") | .id) | first'"
    
    static var FocusTopWindow: String {
        let id = Shell.execute(Commands.GetTopWindowId)
        guard id != "null" else { return "" }
        return "\(BinPath)/yabai -m window \(id) --focus"
    }
    
    static var BringSwitcherToFront: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        let index = Shell.execute(Commands.GetCurrentSpace)
        return "\(BinPath)/yabai -m window \(id) --space \(index); \(BinPath)/yabai -m window \(id) --focus"
    }
    
    static var MoveLeft: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        if id.isEmpty {
            return "\(BinPath)/yabai -m space --focus prev;"
        } else {
            return "\(BinPath)/yabai -m window \(id) --space prev; \(BinPath)/yabai -m space --focus prev; \(BinPath)/yabai -m window \(id) --focus;"
        }
    }
    
    static var MoveRight: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        if id.isEmpty {
            return "\(BinPath)/yabai -m space --focus next;"
        } else {
            return "\(BinPath)/yabai -m window \(id) --space next; \(BinPath)/yabai -m space --focus next; \(BinPath)/yabai -m window \(id) --focus;"
        }
    }
    
    static var MoveUp: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index - Config.row
        if id.isEmpty {
            return "\(BinPath)/yabai -m space --focus \(targetSpace);"
        } else {
            return "\(BinPath)/yabai -m window \(id) --space \(targetSpace); \(BinPath)/yabai -m space --focus \(targetSpace); \(BinPath)/yabai -m window \(id) --focus;"
        }
    }
    
    static var MoveDown: String {
        let id = Shell.execute(Commands.GetAppWindowId)
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index + Config.row
        if id.isEmpty {
            return "\(BinPath)/yabai -m space --focus \(targetSpace);"
        } else {
            return "\(BinPath)/yabai -m window \(id) --space \(targetSpace); \(BinPath)/yabai -m space --focus \(targetSpace); \(BinPath)/yabai -m window \(id) --focus;"
        }
    }
    
    static func MoveWindowLeft(windowId: String) -> String {
        return "\(BinPath)/yabai -m window \(windowId) --space prev; \(BinPath)/yabai -m space --focus prev; \(BinPath)/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowRight(windowId: String) -> String {
        return "\(BinPath)/yabai -m window \(windowId) --space next; \(BinPath)/yabai -m space --focus next; \(BinPath)/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowUp(windowId: String) -> String {
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index - Config.row
        return "\(BinPath)/yabai -m window \(windowId) --space \(targetSpace); \(BinPath)/yabai -m space --focus \(targetSpace); \(BinPath)/yabai -m window \(windowId) --focus"
    }
    
    static func MoveWindowDown(windowId: String) -> String {
        guard let index = Int(Shell.execute(Commands.GetCurrentSpace)) else { return ""}
        let targetSpace = index + Config.row
        return "\(BinPath)/yabai -m window \(windowId) --space \(targetSpace); \(BinPath)/yabai -m space --focus \(targetSpace); \(BinPath)/yabai -m window \(windowId) --focus"
    }
}
