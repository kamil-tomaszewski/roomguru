//
//  EventsListViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

class EventsListViewModel<T: CalendarEntry>: ListViewModel<CalendarEntry> {
    
    private var selectedFreeEventPaths: [NSIndexPath] = []
    
    init(_ items: [T]) {
        super.init(items)
    }
    
    func eventAtIndex(indexPath: NSIndexPath) -> Event? {
        return self[indexPath.row]?.event
    }
    
    func indexOfItemWithDate(date: NSDate) -> Path? {
        
        var pathToReturn: Path?
        
        itemize { (path: Path, item: CalendarEntry) in
            if item.event.start < date {
                pathToReturn = path
            }
        }
        return pathToReturn
    }
    
    func selectOrDeselectFreeEventAtIndexPath(indexPath: NSIndexPath) {
        
        if containsIndexPath(indexPath) {
            selectedFreeEventPaths = selectedFreeEventPaths.filter {$0 != indexPath}
        } else {
            selectedFreeEventPaths.append(indexPath)
        }
    }
    
    func isFreeEventSelectedAtIndex(indexPath: NSIndexPath) -> (selected: Bool, lastUserSelection: Bool) {
        let lastUserSelection = selectedFreeEventPaths.last == indexPath
        return (selected: containsIndexPath(indexPath), lastUserSelection: lastUserSelection)
    }
    
    func indexPathsToReload() -> [NSIndexPath] {
        return selectedFreeEventPaths
    }
    
    func isSelectableIndex(indexPath: NSIndexPath) -> Bool {
        
        // when not free event, allow to select
        if !(eventAtIndex(indexPath) is FreeEvent) {
            return true
        }
        
        // when empty allow to select
        if selectedFreeEventPaths.isEmpty {
            return true
        }
        
        let beforeFreeEvent = isFreeEventBeforeIndexSelected(indexPath)
        let afterFreeEvent = isFreeEventAfterIndexSelected(indexPath)
        
        // when both, means event is in the middle, do not allow
        if beforeFreeEvent && afterFreeEvent {
            return false
        // when one of two, means event is boundary event
        } else if beforeFreeEvent || afterFreeEvent {
            return true
        // when contains, means one event left and this one has been selected
        } else if containsIndexPath(indexPath) {
            return true
        } else {
            return false
        }
    }
    
    func selectedTimeRangeToBook() -> TimeRange? {
        
        var selectedFreeEvents: [Event] = []
        
        itemize { (path: Path, item: CalendarEntry) in
            let indexPath = NSIndexPath(forRow: path.row, inSection: path.section)
            if let index = find(self.selectedFreeEventPaths, indexPath) {
                selectedFreeEvents.append(item.event)
            }
        }
        
        if selectedFreeEvents.isEmpty {
            return nil
        }
        
        selectedFreeEvents.sort { $0.start <= $1.start }
        return TimeRange(min: selectedFreeEvents.first!.start, max: selectedFreeEvents.last!.end)
    }
}

private extension EventsListViewModel {
    
    func containsIndexPath(indexPath: NSIndexPath) -> Bool {
        return find(selectedFreeEventPaths, indexPath) != nil
    }
    
    func isFreeEventAfterIndexSelected(indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == self[0].count) {
            return false
        }
        if let freeEvent = self[indexPath.row + 1]?.event as? FreeEvent {
            let path = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
            return containsIndexPath(path)
        }
        return false
    }
    
    func isFreeEventBeforeIndexSelected(indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == 0) {
            return false
        }
        if let freeEvent = self[indexPath.row - 1]?.event as? FreeEvent {
            let path = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
            return containsIndexPath(path)
        }
        return false
    }
}
