//
//  EventsListView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventsListView: UIBaseTableView {
    
    private(set) var placeholderView: EmptyCalendarPlaceholderView!
    
    override func commonInit() {
        
        placeholderView = EmptyCalendarPlaceholderView(frame: frame, text: NSLocalizedString("Weekend day.\nGo away from your computer and relax!", comment: ""))
        addSubview(placeholderView)
        
        super.commonInit()
        
        tableView.alpha = 0
        placeholderView.hidden = true
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        layout(placeholderView) { placeholder in
            placeholder.edges == placeholder.superview!.edges; return
        }
    }
}
