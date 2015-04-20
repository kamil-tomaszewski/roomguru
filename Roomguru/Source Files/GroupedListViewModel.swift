//
//  GroupedListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias GroupedTable = List<Section<GroupItem>>

class GroupedListViewModel {
    
    init(items: [[GroupItem]]) {
        let sections = items.map { Section($0) }
        self.table = List(sections)
    }
    
    subscript(index: Int) -> Section<GroupItem>? {
        return table[index]
    }
    
    // MARK: Private
    
    private var table: GroupedTable
}

// MARK: UITableView related

extension GroupedListViewModel {
    
    func sectionsCount() -> Int {
        return table.count ?? 0
    }
}

extension GroupedListViewModel {
    
    func addItem(item: GroupItem, atIndexPath indexPath: NSIndexPath) {
        table[indexPath.section]?.add(item, atIndex: indexPath.row)
    }
    
    func removeItemAtIndexPath(indexPath: NSIndexPath) {
        table[indexPath.section]?.remove(indexPath.row)
    }
    
    func enumerate(closure: (item: GroupItem) -> ()) {
        table.enumerate { $0.enumerate { closure(item: $0) } }
    }
}
