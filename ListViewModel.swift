//
//  ListViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class ListViewModel<T> {
    
    typealias Table = List<Section<T>>
    
    var items: List<T>
    
    private var sections: Table?
    private var sortingKey: String?
    
    init(_ items: [T]) {
        self.items = List<T>(items)
    }
    
    init(items: [T], sortingKey: String) {
        self.items = List<T>(items)
        self.sortingKey = sortingKey
        
        self.sections = sectionsFromItems(items, sortingKey: sortingKey)
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
    
    private func sectionsFromItems(items: [T], sortingKey bySortingKey: String) -> Table? {
        return nil;
    }
    
}
