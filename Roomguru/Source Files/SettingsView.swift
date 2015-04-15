//
//  SettingsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class SettingsView: UIBaseTableView {
    
    override func initialize() {
        super.initialize()
                
        tableView.tableHeaderView = SettingsTableHeaderView(frame: CGRectMake(0, 0, 0, 120))
    }
}
