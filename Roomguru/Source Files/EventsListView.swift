//
//  EventsListView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsListView: UIBaseTableView {
    
    override func initialize() {
        super.initialize()
        
        tableView.tableHeaderView = buttonView(NSLocalizedString("Future", comment: ""))
        tableView.tableFooterView = buttonView(NSLocalizedString("Past", comment: ""))
    }
    
    private func buttonView(title: String) -> ButtonView {
        let frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)
        
        var buttonView = ButtonView(frame: frame)
        buttonView.button.setTitle(title)
        
        return buttonView
    }
}
