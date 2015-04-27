//
//  SettingsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class SettingItem: NSObject {
    
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

class SettingsViewModel<T: SettingItem>: ListViewModel<SettingItem> {
    
    let settingsStore = SettingsStore()
    
    init(_ items: [T]) {
        super.init(items)
    }
    
    func isSelectableItemAtIndex(index: Int) -> Bool {
        return self[index]!.mode == .Selectable
    }
}
