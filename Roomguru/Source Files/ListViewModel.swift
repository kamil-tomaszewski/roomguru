//
//  ListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


class ListViewModel<T: NSObject> {
    
    typealias Table = List<Section<T>>
    
    var items: List<T>
    
    private var sections: Table?
    private var sortingKey: String?
    
    init(_ items: [T], sortingKey: String) {
        self.items = List<T>(items)
        self.sortingKey = sortingKey
        
        self.sections = sectionsFromItems(items, bySortingKey: sortingKey)
    }
    
    subscript(index: Int) -> List<T> {
        if let _sections = sections {
            return _sections[index]
        }
        return items
    }
    
    // NGRFixme: Is this second subscript needed?
    subscript(index: Int) -> T {
        return items[index]
    }
    
    func sectionsCount() -> Int {
        return self.sections?.count ?? 1
    }
    
    func removeAtIndexPath(indexPath: NSIndexPath) {
        if sections?.count > 0 {
            sections?[indexPath.section].remove(indexPath.row)
        } else {
            items.remove(indexPath.row)
        }
    }
}

// MARK: Private

extension ListViewModel {
    
    private func sectionsFromItems(items: [T], bySortingKey sortingKey: String) -> Table? {
        
        let values: [NSObject?] = items.map({ (item: NSObject) -> NSObject? in
            return item.valueForKeyPath(sortingKey) as? NSObject
        })
        
        var uniques: [NSObject] = []
        
        for item in values {
            if let _item = item {
                if !contains(uniques, _item) {
                    uniques.append(_item)
                }
            }
        }
        
        let sections: [Section<T>] = uniques.map({ (item: NSObject) -> Section<T> in
            let allMatchingItems = items.itemsMatching(item, bySortingKey: sortingKey)
            let section: Section<T> = Section<T>(allMatchingItems)
            if let item = item as? StringConvertible {
                section.title = item.string()
            }
            return section
        })
        
        return Table(sections)
    }
}

extension Array {
    
    func itemsMatching(item: NSObject, bySortingKey key: String) -> [T] {
        return self.filter ({ (_item) -> Bool in
            if let object = _item as? NSObject {
                if let newItem = object.valueForKeyPath(key) as? NSObject {
                    return newItem == item
                }
            }
            return false
        })
    }
}
