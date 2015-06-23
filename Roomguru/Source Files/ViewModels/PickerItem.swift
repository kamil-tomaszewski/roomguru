//
//  PickerItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 22/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class PickerItem: NSObject {
    var title: String
    var selected: Bool
    
    init(title: String = "", selected: Bool = false) {
        self.title = title
        self.selected = selected
    }
}
