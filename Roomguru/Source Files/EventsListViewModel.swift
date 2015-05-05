//
//  EventsListViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class EventsListViewModel<T: CalendarEntry>: ListViewModel<CalendarEntry> {
    
    init(_ items: [T], sortingKey: String) {
        super.init(items, sortingKey: sortingKey)
    }
    
    func eventAtIndex(indexPath: NSIndexPath) -> Event? {
        
        if sectionsCount() > 1 {
            return self[indexPath.section][indexPath.row].event
        }
        return self[indexPath.row]?.event
    }
    
    func indexOfItemWithDate(date: NSDate) -> Path? {
        
        var pathToReturn: Path?
        
        itemize { (path: Path, item: CalendarEntry) in
            if date.between(earlier: item.event.start!, later: item.event.end!) {
                pathToReturn = path
            }
        }
        return pathToReturn
    }
}
