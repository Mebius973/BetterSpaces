//
//  EventListener.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 21/03/2022.
//

import SwiftUI
import Carbon
import HotKey

extension String {
  /// This converts string to UInt as a fourCharCode
  public var fourCharCodeValue: Int {
    var result: Int = 0
    if let data = self.data(using: String.Encoding.macOSRoman) {
      data.withUnsafeBytes({ (rawBytes) in
        let bytes = rawBytes.bindMemory(to: UInt8.self)
        for i in 0 ..< data.count {
          result = result << 8 + Int(bytes[i])
        }
      })
    }
    return result
  }
}

class EventListener {
    var opt = false
    
    func register() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            self.opt = event.modifierFlags.contains(.option)

            if self.opt {
                self.registerWindowHotkeys()
                var modifierFlags: UInt32 = self.getCarbonFlagsFromCocoaFlags(cocoaFlags: .control)
                modifierFlags += self.getCarbonFlagsFromCocoaFlags(cocoaFlags: .option)
                self.registerKeys(modifierFlags: modifierFlags)
                
            } else {
                self.registerMoveHotkeys()
                var modifierFlags: UInt32 = self.getCarbonFlagsFromCocoaFlags(cocoaFlags: .control)
                self.registerKeys(modifierFlags: modifierFlags)
            }
        }
//        addListener()
//        registerKeys()
    }
    
    func registerWindowHotkeys() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
          (nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil,  MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            switch hkCom.id {
            case UInt32(kVK_LeftArrow):
                let command = Commands.MoveWindowLeft.rawValue
                return Shell.execute(command)
            case UInt32(kVK_RightArrow):
                let command = Commands.MoveWindowRight.rawValue
                return Shell.execute(command)
            case UInt32(kVK_UpArrow):
                let command = Commands.MoveWindowUp.rawValue
                return Shell.execute(command)
            case UInt32(kVK_DownArrow):
                let command = Commands.MoveWindowDown.rawValue
                return Shell.execute(command)
            default:
                return 0
            }
        }, 1, &eventType, nil, nil)
    }
    func registerMoveHotkeys() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
          (nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil,  MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            switch hkCom.id {
            case UInt32(kVK_LeftArrow):
                let command = Commands.MoveLeft.rawValue
                return Shell.execute(command)
            case UInt32(kVK_RightArrow):
                let command = Commands.MoveRight.rawValue
                return Shell.execute(command)
            case UInt32(kVK_UpArrow):
                let command = Commands.MoveUp.rawValue
                return Shell.execute(command)
            case UInt32(kVK_DownArrow):
                let command = Commands.MoveDown.rawValue
                return Shell.execute(command)
            default:
                return 0
            }
        }, 1, &eventType, nil, nil)
    }
    
    func addListener() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
          (nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil,  MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            switch hkCom.id {
            case UInt32(kVK_LeftArrow):
                let command = Commands.MoveLeft.rawValue
                return Shell.execute(command)
            case UInt32(kVK_RightArrow):
                let command = Commands.MoveRight.rawValue
                return Shell.execute(command)
            case UInt32(kVK_UpArrow):
                let command = Commands.MoveUp.rawValue
                return Shell.execute(command)
            case UInt32(kVK_DownArrow):
                let command = Commands.MoveDown.rawValue
                return Shell.execute(command)
            default:
                return 0
            }
        }, 1, &eventType, nil, nil)
    }
    
    func registerKeys(modifierFlags: UInt32) {
        registerKey(kVK_LeftArrow, modifierFlags: modifierFlags)
        registerKey(kVK_RightArrow, modifierFlags: modifierFlags)
        registerKey(kVK_UpArrow, modifierFlags: modifierFlags)
        registerKey(kVK_DownArrow, modifierFlags: modifierFlags)
    }
    
    func registerKey(_ key: Int, modifierFlags: UInt32) {
        var hotKeyRef: EventHotKeyRef?

        let keyCode = key
        var gMyHotKeyID = EventHotKeyID()
        gMyHotKeyID.id = UInt32(keyCode)
        gMyHotKeyID.signature = OSType("swat".fourCharCodeValue)

        let status = RegisterEventHotKey(UInt32(keyCode),
                                       modifierFlags,
                                       gMyHotKeyID,
                                       GetApplicationEventTarget(),
                                       0,
                                       &hotKeyRef)
        assert(status == noErr)
    }
    
    func getCarbonFlagsFromCocoaFlags(cocoaFlags: NSEvent.ModifierFlags) -> UInt32 {
        let flags = cocoaFlags.rawValue
        var newFlags: Int = 0

        if ((flags & NSEvent.ModifierFlags.control.rawValue) > 0) {
            newFlags |= controlKey
        }

        if ((flags & NSEvent.ModifierFlags.command.rawValue) > 0) {
            newFlags |= cmdKey
        }

        if ((flags & NSEvent.ModifierFlags.shift.rawValue) > 0) {
            newFlags |= shiftKey;
        }

        if ((flags & NSEvent.ModifierFlags.option.rawValue) > 0) {
            newFlags |= optionKey
        }

        if ((flags & NSEvent.ModifierFlags.capsLock.rawValue) > 0) {
            newFlags |= alphaLock
        }

        return UInt32(newFlags);
    }
}
