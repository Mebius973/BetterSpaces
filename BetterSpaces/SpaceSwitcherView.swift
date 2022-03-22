//
//  SpaceSwitcherView.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation
import AppKit

class SpaceSwitcherView: SpaceSwitcherViewProtocol {
    var indicatorView: SpaceSwitchingIndicatorView
    var window: NSWindow
    var spaceSelector: SpaceSelector
    private var to = 0
    
    func showSwitcher() {
        window.setIsVisible(true)
        window.orderFrontRegardless()
    }
    
    func switchSpace(to: Int) {
        self.to = to
        Timer.scheduledTimer(timeInterval: 0.07, target: self, selector: #selector(beginSwitch), userInfo: nil, repeats: false)
    }
    

    @objc func beginSwitch() {
        spaceSelector.selectedSpace = self.to
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(endSwitch), userInfo: nil, repeats: false)
        
    }
    
    @objc func endSwitch() {
        window.setIsVisible(false)
    }
    
    init(window: NSWindow, indicatorView: SpaceSwitchingIndicatorView, spaceSelector: SpaceSelector) {
        self.window = window
        self.indicatorView = indicatorView
        self.spaceSelector = spaceSelector
    }
}
