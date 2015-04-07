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
    subscript(index: Int) -> Type { get }
    
    func remove(index: Int)
}


// MARK: List

class List<T> : Listable {
    
    var count: Int { get { return items.count } }
    
    private var items: [T]
    
    required init(_ items: [T]) {
        self.items = items
    }
    
    subscript(index: Int) -> T {
        return items[index]
    }
    
    func remove(index: Int) {
        items.removeAtIndex(index)
    }
}


// MARK: Section

class Section<T> : List<T> {
    
    var title: String?
    
    required init(_ items: [T]) {
        super.init(items)
    }
    
}
