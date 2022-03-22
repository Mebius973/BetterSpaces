//
//  AppDelegate.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 09/03/2022.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var view: SpaceSwitchingIndicatorView!
    private var window: NSWindow!
    private var statusItem: NSStatusItem!
    private var spaceSelector = SpaceSelector()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        view = SpaceSwitchingIndicatorView(rows: 3, columns: 3, spaceSelector: spaceSelector)
        
        window = NSWindow(
                   contentRect: NSRect(x: 0, y: 0, width: 480, height: 270),
                   styleMask: [.borderless],
                   backing: .buffered, defer: false)
        window.center()
        window.backgroundColor = .clear
        window.contentView = NSHostingView(rootView: view)
        window.setIsVisible(false)
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        
        setupMenus()
        
        EventListener().register()
    }
    
    func setupMenus() {
        let menu = NSMenu()

        let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        menu.addItem(one)

        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
        menu.addItem(two)

        let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")
        menu.addItem(three)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

        statusItem.menu = menu
    }
    
    private func changeStatusBarButton(number: Int) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
            window.setIsVisible(true)
            window.orderFrontRegardless()
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(switchSpace), userInfo: nil, repeats: false)
            
        }
    }

    @objc func switchSpace() {
        spaceSelector.selectedSpace = 3
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideWindow), userInfo: nil, repeats: false)
        
    }
    
    @objc func hideWindow() {
        window.setIsVisible(false)
    }
    
    @objc func didTapOne() {
        changeStatusBarButton(number: 1)
    }

    @objc func didTapTwo() {
        changeStatusBarButton(number: 2)
    }

    @objc func didTapThree() {
        changeStatusBarButton(number: 3)
    }
}
