//
//  SpaceSwitcherControllerProtocol.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation

protocol SpaceSwitcherControllerProtocol {
    var spaceSwitcherViewDelegate: SpaceSwitcherViewProtocol { get set }
    var spaceSelector: SpaceSelector { get set }
    func switchSpaceLeft()
    func switchSpaceRight()
    func switchSpaceUp()
    func switchSpaceDown()
    func switchWindowLeft()
    func switchWindowRight()
    func switchWindowUp()
    func switchWindowDown()
}
