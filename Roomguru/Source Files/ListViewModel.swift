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
    
    init(_ items: [T]) {
        self.items = List<T>(items)
    }
    
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
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
    func sectionsCount() -> Int {
        if let sections = self.sections {
            return sections.count
        }
        return 1
    }
    
}


// MARK: Private

extension ListViewModel {
    
    private func sectionsFromItems(items: [T], bySortingKey sortingKey: String) -> Table? {
        
        var sections: [Section<T>] = []
        let values: [NSObject?] = items.map({ (item: NSObject) -> NSObject? in
            return item.valueForKeyPath(sortingKey) as? NSObject
        })
        
        var uniques: [NSObject?] = []
        
        for item in values {
            if let _item = item {
                if uniques.contains(_item) == false {
                    uniques.append(_item)
                }
            }
        }
        
        for item in uniques {
            let allMatchingItems = items.itemsMatching(item!, bySortingKey: sortingKey)
            let section = Section<T>(allMatchingItems)
            
            if let _item: StringConvertible = item as? StringConvertible {
                section.title = _item.string()
            }
            
            sections.append(section)
        }
        
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
