//
//  EventsListView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventsListView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        addSubview(tableView)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(tableView) { table in
            
            table.top == table.superview!.top
            table.width == table.superview!.width
            table.bottom == table.superview!.bottom
            
        }
    }
    
}
