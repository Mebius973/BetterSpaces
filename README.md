# BetterSpaces #

Given Binaryage's Totalspaces2 is not supporting os x Monterey, working on mac os has become worse than ever (wake up Apple! Give us our spaces back from what they ware back in lion!).

This repo is an attempt to build some alternative.

The solution builds on top of [Yabai](https://github.com/koekeishiya/yabai) which is a tiling window manager for macos and allows for spaces manipulation.
Using keyboards hotkeys for space management works using [skhd](https://github.com/koekeishiya/skhd).

The cavits of yabai + skhd:
- no graphical tool for basic configuration
- no graphical indicator when switching spaces
- no support for trackpad gestures
- tedious intallation

This repos aims at filling those cavits, taking advantage of the capacity of yabai to emit messages.
