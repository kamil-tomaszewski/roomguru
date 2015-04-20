//
//  ActionItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ActionItem: GroupItem {
    
    var action: VoidBlock
    var detailDescription: String
    
    init(title: String, detailDescription: String = "", action: VoidBlock) {
        self.action = action
        self.detailDescription = detailDescription
        super.init(title: title, category: .Action)
    }
}
