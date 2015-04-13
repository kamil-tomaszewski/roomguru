//
//  GroupedBaseTableView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class GroupedBaseTableView: UIBaseTableView {
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Grouped)
    }
}
