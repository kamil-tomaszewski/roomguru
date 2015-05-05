//
//  ListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias Path = (section: Int, row: Int)

protocol Itemizable {
    typealias T
    func itemize(closure: (path: Path, item: T) -> ())
}

protocol IndexPathOperatable {
    typealias T
    func addItem(item: T, atIndexPath indexPath: NSIndexPath)
    func removeAtIndexPath(indexPath: NSIndexPath)
    func removeItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class ListViewModel<T: NSObject> {
    
    typealias Table = List<Section<T>>
    
    private var sections: Table = Table([Section<T>([])])
    private var sortingKey: String?
    
    required init(_ items: [T]) {
        sections = Table([Section<T>(items)])
    }
    
    required init(_ items: [T], sortingKey: String) {
        self.sortingKey = sortingKey
        sections = sectionsFromItems(items, bySortingKey: sortingKey) ?? Table([Section<T>(items)])
    }
    
    required init(_ sections: [Section<T>]) {
        self.sections = Table(sections)
    }
    
    subscript(index: Int) -> List<T> {
        return sections[index]
    }
    
    subscript(index: Int) -> T? {
        return sections[0][index]
    }
        
    func sectionsCount() -> Int {
        return sections.count
    }
}

// MARK: Itemizable

extension ListViewModel: Itemizable {
    
    func itemize(closure: (path: Path, item: T) -> ()) {
        sections.itemize { section, item in
            item.itemize { closure(path: (section, $0), item: $1) }
        }
    }
}

// MARK: IndexPathOperatable

extension ListViewModel: IndexPathOperatable {
    
    func addItem(item: T, atIndexPath indexPath: NSIndexPath) {
        sections[indexPath.section].add(item, atIndex: indexPath.row)
    }
    
    func removeAtIndexPath(indexPath: NSIndexPath) {
        sections[indexPath.section].remove(indexPath.row)
    }
    
    func removeItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        for indexPath in indexPaths {
            removeAtIndexPath(indexPath)
        }
    }
}

// MARK: Private

private extension ListViewModel {
    
    func sectionsFromItems(items: [T], bySortingKey sortingKey: String) -> Table? {
        
        let values: [NSObject?] = items.map { (item: NSObject) -> NSObject? in
            item.valueForKeyPath(sortingKey) as? NSObject
        }
        
        var uniques: [NSObject] = []
        
        for value in values {
            if let value = value {
                if !contains(uniques, value) {
                    uniques.append(value)
                }
            }
        }
        
        let sections: [Section<T>] = uniques.map { (item: NSObject) -> Section<T> in
            let allMatchingItems = items.itemsMatching(item, bySortingKey: sortingKey)
            let section: Section<T> = Section<T>(allMatchingItems)
            
            if let item = item as? StringConvertible {
                section.title = item.string()
            }
            return section
        }
        
        return Table(sections)
    }
}

private extension Array {
    
    func itemsMatching(item: NSObject, bySortingKey key: String) -> [T] {
        return self.filter { _item in
            if let object = _item as? NSObject {
                if let newItem = object.valueForKeyPath(key) as? NSObject {
                    return newItem == item
                }
            }
            return false
        }
    }
}
