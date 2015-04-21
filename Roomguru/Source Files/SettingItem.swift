//
//  SettingItem.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct SettingItem {
    
    let title: String
    let action: Selector
    let mode: Mode
    
    enum Mode {
        case Switchable, Selectable
    }
    
    init(title: String, mode: Mode, action: Selector) {
        self.title = title
        self.mode = mode
        self.action = action
    }
}
