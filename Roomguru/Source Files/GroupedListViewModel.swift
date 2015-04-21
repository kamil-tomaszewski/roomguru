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
    
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        table.itemize { (index, item) in
            var section = index
            item.itemize { (index, item) in
                if contains(items, item) {
                    indexPaths.append(NSIndexPath(forRow: index, inSection: section))
                }
            }
        }

        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func indexPathsForItemOfType<T: GroupItem>(itemType: T.Type) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        table.itemize { (index, item) in
            var section = index
            item.itemize { (index, item) in
                if item is T {
                    indexPaths.append(NSIndexPath(forRow: index, inSection: section))
                }
            }
        }
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func removeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            removeItemAtIndexPath(indexPath)
        }
    }
}

extension GroupedListViewModel {
    
    func addItem(item: GroupItem, atIndexPath indexPath: NSIndexPath) {
        table[indexPath.section]?.add(item, atIndex: indexPath.row)
    }
    
    func removeItemAtIndexPath(indexPath: NSIndexPath) {
        table[indexPath.section]?.remove(indexPath.row)
    }
    
    func itemize(closure: (index: Int, item: GroupItem) -> ()) {
        table.itemize { $1.itemize { closure(index: $0, item: $1) } }
    }
}
