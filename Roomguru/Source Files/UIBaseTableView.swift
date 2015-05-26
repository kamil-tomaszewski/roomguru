//
//  UIBaseTableView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class UIBaseTableView: UIView {
    
    private(set) var loadingSpinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray);
    private(set) var tableView = EventedTableView()
    
    convenience override init(frame: CGRect) {
        self.init(frame: frame, tableViewStyle: .Plain)
    }
    
    init(frame: CGRect, tableViewStyle: UITableViewStyle) {
        tableView = EventedTableView(frame: frame, style: tableViewStyle)
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        tableView.hideSeparatorForEmptyCells()
        addSubview(tableView)
        addSubview(loadingSpinner)
        defineConstraints()
        
        tableView.didReloadWithData = {
            self.loadingSpinner.stopAnimating()
        }
        tableView.didReloadWithoutData = {
            if !self.loadingSpinner.isAnimating() {
                self.loadingSpinner.startAnimating()
            }
        }
    }
    
    func defineConstraints() {
        
        layout(tableView, loadingSpinner) { table, spinner in
            table.edges == table.superview!.edges;
            spinner.center == table.center;
        }
    }
}
