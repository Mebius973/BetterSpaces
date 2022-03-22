//
//  Commands.swift
//  BetterSpaces
//
//  Created by David GEOFFROY on 22/03/2022.
//

import Foundation

enum Commands: String {
    case MoveLeft = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')` && if [ $(expr $index % 3) != \"1\" ]; then /usr/local/bin/yabai -m space --focus prev; fi"
    case MoveRight = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')` && if [ $(expr $index % 3) != \"0\" ]; then /usr/local/bin/yabai -m space --focus next; fi"
    case MoveUp = "/usr/local/bin/yabai -m space --focus `expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index') - 3`"
    case MoveDown = "/usr/local/bin/yabai -m space --focus `expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index') + 3`"
    case MoveWindowLeft = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')` && if [ $(expr $index % 3) != \"1\" ]; then /usr/local/bin/yabai -m window --space prev; /usr/local/bin/yabai -m space --focus prev; fi"
    case MoveWindowRight = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index')` && if [ $(expr $index % 3) != \"0\" ]; then /usr/local/bin/yabai -m window --space next; /usr/local/bin/yabai -m space --focus next; fi"
    case MoveWindowUp = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index') - 3` && /usr/local/bin/yabai -m window --space $index && /usr/local/bin/yabai -m space --focus $index"
    case MoveWindowDown = "index=`expr $(/usr/local/bin/yabai -m query --spaces --space | /usr/local/bin/jq '.index') + 3` && /usr/local/bin/yabai -m window --space $index && /usr/local/bin/yabai -m space --focus $index"
}
