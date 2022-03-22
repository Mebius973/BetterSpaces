//
//  SpaceSwitcherViewProtocol.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation
import AppKit

protocol SpaceSwitcherViewProtocol {
    var indicatorView: SpaceSwitchingIndicatorView { get set }
    var window: NSWindow { get set }
    var spaceSelector: SpaceSelector { get set }
    func showSwitcher()
    func switchSpace(to: Int)
}
