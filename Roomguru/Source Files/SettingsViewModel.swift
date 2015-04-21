//
//  SettingsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class SettingsViewModel {
    
    private let items : [SettingItem]
    
    init() {
        self.items = [
            SettingItem(title: NSLocalizedString("Manage calendars", comment: ""), mode: .Selectable, action: Selector("didTapManageCalendars"))
        ]
    }
    
    subscript(index: Int) -> SettingItem {
        return items[index]
    }

    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }
}
