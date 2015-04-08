//
//  SettingsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class SettingsViewModel: NSObject {
    
    private let items : [SettingItem]
    
    init(items: [SettingItem]) {
        self.items = items
        super.init()
    }
    
    subscript(index: Int) -> SettingItem {
        return items[index]
    }

    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    func signatures() -> [String : AnyClass] {
        var dictionary: [String : AnyClass] = [:]
        for type in items {
            dictionary[type.signature().identifier] = type.signature().registeredClass
        }
        return dictionary
    }
}
