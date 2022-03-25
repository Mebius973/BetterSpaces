//
//  SpaceSwitcherController.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation
//#pragma warning ignored
struct SpaceSwitcherController: SpaceSwitcherControllerProtocol {
    var spaceSelector: SpaceSelector
    var spaceSwitcherViewDelegate: SpaceSwitcherViewProtocol
    
    func showSwitcher() {
        spaceSwitcherViewDelegate.showSwitcher()
    }
    
    func switchSpaceLeft() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace % Config.column != 1 else { return }
        spaceSelector.selectedSpace = currentSpace
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace - 1 )
        let _ = Shell.execute(Commands.MoveLeft)
        let _ = Shell.execute(Commands.FocusTopWindow)
    }
    
    func switchSpaceRight() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace % Config.column != 0 else { return }
        spaceSelector.selectedSpace = currentSpace
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace + 1 )
        let _ = Shell.execute(Commands.MoveRight)
        let _ = Shell.execute(Commands.FocusTopWindow)
    }
    
    func switchSpaceUp()  {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace > Config.row else { return }
        spaceSelector.selectedSpace = currentSpace
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace - Config.column )
        let _ = Shell.execute(Commands.MoveUp)
        let _ = Shell.execute(Commands.FocusTopWindow)
    }
    
    func switchSpaceDown()  {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace <= Config.row * (Config.column - 1) else { return }
        spaceSelector.selectedSpace = currentSpace
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace + Config.column )
        let _ = Shell.execute(Commands.MoveDown)
        let _ = Shell.execute(Commands.FocusTopWindow)
    }
    
    func switchWindowLeft() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace % Config.column != 1 else { return }
        spaceSelector.selectedSpace = currentSpace
        let windowId = Shell.execute(Commands.GetCurrentWindowId)
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace - 1 )
        let _ = Shell.execute(Commands.MoveWindowLeft(windowId: windowId))
    }
    
    func switchWindowRight() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace % Config.column != 0 else { return }
        spaceSelector.selectedSpace = currentSpace
        let windowId = Shell.execute(Commands.GetCurrentWindowId)
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace + 1 )
        let _ = Shell.execute(Commands.MoveWindowRight(windowId: windowId))
    }
    
    func switchWindowUp() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace > Config.row else { return }
        spaceSelector.selectedSpace = currentSpace
        let windowId = Shell.execute(Commands.GetCurrentWindowId)
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace - Config.column )
        let _ = Shell.execute(Commands.MoveWindowUp(windowId: windowId))
    }
    
    func switchWindowDown() {
        guard let currentSpace = Int(Shell.execute(Commands.GetCurrentSpace)),
              currentSpace <= Config.row * (Config.column - 1) else { return }
        spaceSelector.selectedSpace = currentSpace
        let windowId = Shell.execute(Commands.GetCurrentWindowId)
        spaceSwitcherViewDelegate.showSwitcher()
        let _ = Shell.execute(Commands.BringSwitcherToFront)
        spaceSwitcherViewDelegate.switchSpace(to: currentSpace + Config.column )
        let _ = Shell.execute(Commands.MoveWindowDown(windowId: windowId))
    }
}
