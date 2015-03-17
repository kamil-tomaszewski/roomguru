//
//  SettingsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SettingsView: UIView {
    
    var tableView = UITableView(frame: CGRectZero, style: .Grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(tableView)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(tableView) { table in
            table.edges == table.superview!.edges; return
        }
    }
}
