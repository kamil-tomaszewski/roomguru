//
//  EventDetailsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventDetailsView: UIBaseTableView {
    
    override func commonInit() {
        super.commonInit()
        
        tableView.hideSeparatorForEmptyCells()
    }
}
