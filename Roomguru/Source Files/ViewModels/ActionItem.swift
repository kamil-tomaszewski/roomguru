//
//  ActionItem.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 19/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class ActionItem: GroupItem {
    
    var action: VoidControllerBlock?
    var detailDescription: String
    
    init(title: String, detailDescription: String = "") {
        self.detailDescription = detailDescription
        super.init(title: title, category: .Action)
    }
}
