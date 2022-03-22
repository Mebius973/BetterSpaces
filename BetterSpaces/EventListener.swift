//
//  EventListener.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 21/03/2022.
//

import SwiftUI
import Carbon

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
    static var spaceSwitcherDelegate: SpaceSwitcherControllerProtocol?
    var mainModifier: NSEvent.ModifierFlags = .control
    var secondaryModifier: NSEvent.ModifierFlags = .option
    var isSecondaryModifierPressed = false
    var eventHandlerRef: EventHandlerRef?
    
    func register() {
        var modifierFlags: UInt32 = self.getCarbonFlagsFromCocoaFlags(cocoaFlags: self.mainModifier)
        self.registerKeys(modifierFlags: modifierFlags)
        modifierFlags += self.getCarbonFlagsFromCocoaFlags(cocoaFlags: self.secondaryModifier)
        self.registerKeys(modifierFlags: modifierFlags)
        
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            self.clearHandler()
            self.isSecondaryModifierPressed = event.modifierFlags.contains(self.secondaryModifier)
            if self.isSecondaryModifierPressed {
                self.registerWindowHandler()
            } else {
                self.registerSpaceHandler()
            }
        }
    }
    
    func clearHandler() {
        if let eventHandlerRef = eventHandlerRef {
            RemoveEventHandler(eventHandlerRef)
        }
    }
    
    func registerSpaceHandler() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
          (nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil,  MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            EventListener.MoveSpacesHanlder(hkCom: hkCom)
            return 0
        }, 1, &eventType, nil, &eventHandlerRef)
    }
    
    func registerWindowHandler() {
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyReleased)

        InstallEventHandler(GetApplicationEventTarget(), {
          (nextHanlder, theEvent, userData) -> OSStatus in
            var hkCom = EventHotKeyID()
            GetEventParameter(theEvent, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil,  MemoryLayout<EventHotKeyID>.size, nil, &hkCom)
            EventListener.MoveWindowsHanlder(hkCom: hkCom)
            return 0
        }, 1, &eventType, nil, &eventHandlerRef)
    }
    
    static func MoveSpacesHanlder(hkCom: EventHotKeyID) {
        if let spaceSwitcher = EventListener.spaceSwitcherDelegate {
            switch hkCom.id {
            case UInt32(kVK_LeftArrow):
                spaceSwitcher.switchSpaceLeft()
            case UInt32(kVK_RightArrow):
                spaceSwitcher.switchSpaceRight()
            case UInt32(kVK_UpArrow):
                spaceSwitcher.switchSpaceUp()
            case UInt32(kVK_DownArrow):
                spaceSwitcher.switchSpaceDown()
            default:
                return
            }
        }
    }
    
    static func MoveWindowsHanlder(hkCom: EventHotKeyID) {
        if let spaceSwitcher = EventListener.spaceSwitcherDelegate {
            switch hkCom.id {
            case UInt32(kVK_LeftArrow):
                spaceSwitcher.switchWindowLeft()
            case UInt32(kVK_RightArrow):
                spaceSwitcher.switchWindowRight()
            case UInt32(kVK_UpArrow):
                spaceSwitcher.switchWindowUp()
            case UInt32(kVK_DownArrow):
                spaceSwitcher.switchWindowDown()
            default:
                return
            }
        }
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
