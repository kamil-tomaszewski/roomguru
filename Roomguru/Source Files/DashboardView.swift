//
//  DashboardView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DashboardView: UIView {
    
    var tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        tableView.showsVerticalScrollIndicator = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .None
        
        tableView.backgroundColor = UIColor.redColor()
        
        addSubview(tableView)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(tableView) { table in
            table.edges == table.superview!.edges; return
        }
    }

}
