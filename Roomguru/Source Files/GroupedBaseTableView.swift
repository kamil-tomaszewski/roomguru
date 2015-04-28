//
//  GroupedBaseTableView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class GroupedBaseTableView: UIBaseTableView {
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Grouped)
    }
}
