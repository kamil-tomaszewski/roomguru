//
//  GroupedListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

protocol ExtendedIndexPathOperatable: IndexPathOperatable {
    typealias T
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]?
    func indexPathsForItemOfType<T: GroupItem>(itemType: T.Type) -> [NSIndexPath]?
}

class GroupedListViewModel<T: GroupItem>: ListViewModel<T> {
    
    init(items: [[T]]) {
        let sections = items.map { Section($0) }
        super.init(sections)
    }
}

extension GroupedListViewModel: ExtendedIndexPathOperatable {
    
    func indexPathsForItems(items: [GroupItem]) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []

        itemize { (path, item) -> () in
            if contains(items, item) {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        
        return indexPaths.isEmpty ? nil : indexPaths
    }
    
    func indexPathsForItemOfType<T: GroupItem>(itemType: T.Type) -> [NSIndexPath]? {
        var indexPaths: [NSIndexPath] = []
        
        itemize { path, item in
            if item is T {
                indexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        return indexPaths.isEmpty ? nil : indexPaths
    }
}
