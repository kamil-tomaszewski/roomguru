//
//  Listable.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 18/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


protocol Listable {
    
    typealias Type
    
    var count: Int { get }
    
    init(_ items: [Type])
    subscript(index: Int) -> Type? { get }
    
    func add(item: Type, atIndex index: Int)
    func remove(index: Int)
    
    func itemize(closure: (index: Int, item: Type) -> ())
}


// MARK: List

class List<T> : Listable {
    
    var count: Int { get { return items.count } }
    
    var items: [T]
    
    required init(_ items: [T]) {
        self.items = items
    }
    
    subscript(index: Int) -> T? {
        if index < items.count {
            return items[index]
        }
        return nil
    }
    
    func add(item: T, atIndex index: Int) {
        items.insert(item, atIndex: index)
    }
    
    func remove(index: Int) {
        items.removeAtIndex(index)
    }
    
    func itemize(closure: (index: Int, item: T) -> ()) {
        for (index, item) in enumerate(items) {
            closure(index: index, item: item)
        }
    }
}


// MARK: Section

class Section<T> : List<T> {
    
    var title: String?
    
    required init(_ items: [T]) {
        super.init(items)
    }
    
}
