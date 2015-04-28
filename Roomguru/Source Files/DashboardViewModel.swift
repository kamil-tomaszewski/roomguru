//
//  DashboardViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class DashboardViewModel: NSObject {
    
    private var items: [CellItem]
    
    init(items: [CellItem]) {
        self.items = items
        super.init()
    }
    
    subscript(index: Int) -> CellItem {
        return items[index]
    }
}

// MARK: 

extension DashboardViewModel {
    
    func numberOfItems() -> Int {
        return items.count
    }
}

// MARK: CellItem

class CellItem {
    
    enum CellItemAction { case Book, Revoke }
    
    let title: String
    let action: CellItemAction
    var color: UIColor { get { return _color } }
    
    init(title: String, action: CellItemAction) {
        self.title = title
        self.action = action
        
        switch action {
        case .Book: _color = UIColor.ngOrangeColor()
        default: _color = UIColor.ngRedColor()
        }
    }
    
    // MARK: Private
    
    private let _color: UIColor
}
