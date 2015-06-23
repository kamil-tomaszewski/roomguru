//
//  EventedTableView.swift
//  Roomguru
//
//  Created by Wojciech Trzasko on 26.05.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventedTableView : UITableView {
    
    var didReloadWithData: VoidBlock?
    var didReloadWithoutData: VoidBlock?
    
    override func reloadData() {
        super.reloadData()
        
        if let datasource = dataSource {
            let numberOfRows = datasource.tableView(self, numberOfRowsInSection: 0)
            numberOfRows > 0 ? didReloadWithData?() : didReloadWithoutData?()
        } else {
            didReloadWithoutData?()
        }
    }
}
