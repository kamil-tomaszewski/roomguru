//
//  EditEventViewModel.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 14/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
import DateKit

protocol ModelUpdatable {
    func didChangeItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func addedItemsAtIndexPaths(indexPaths: [NSIndexPath])
    func removedItemsAtIndexPaths(indexPaths: [NSIndexPath])
}

class EditEventViewModel: GroupedListViewModel {
    
    var delegate: ModelUpdatable?
    var title: String
    
    convenience init(calendarEntry: CalendarEntry) {
        let query = EventQuery(calendarEntry: calendarEntry)
        self.init(query: query)
        title = NSLocalizedString("Edit Event", comment: "")
    }
    
    convenience init() {
        self.init(query: EventQuery())
    }
    
    init(query: EventQuery) {
        
        title = NSLocalizedString("New Event", comment: "")

        // MARK: Parameters
        
        let summary = query.summary
        let summaryPlaceholder = NSLocalizedString("Summary", comment: "")
        let allDayTitle = NSLocalizedString("All-day", comment: "")
        let startDateTitle = NSLocalizedString("Starts", comment: "")
        let endDateTitle = NSLocalizedString("Ends", comment: "")
        let repeatTitle = NSLocalizedString("Repeat", comment: "")
        let noneDetail = NSLocalizedString("None", comment: "")
        let calendarTitle = NSLocalizedString("Room", comment: "")
        let longTextPlaceholder = NSLocalizedString("Description", comment: "")
        
        // MARK: Create items
        
        let summaryItem = TextItem(title: summary, placeholder: summaryPlaceholder, text: summaryPlaceholder) { text in
            query.summary = text
        }
        
        let allDayItem = SwitchItem(title: allDayTitle)
        let startDateItem = DateItem(title: startDateTitle)
        let endDateItem = DateItem(title: endDateTitle, date: startDateItem.date.minutes + 30)
        
        let repeatItem = ActionItem(title: repeatTitle, detailDescription: noneDetail) {
            // NGRTodo: present controller
        }
        
        let calendarItem = ActionItem(title: calendarTitle, detailDescription: noneDetail) {
            // NGRTodo: present controller
        }
        
        let descriptionItem = LongTextItem(placeholder: longTextPlaceholder)
        
        eventQuery = query
        
        // MARK: Super init
        
        super.init(items: [
            [summaryItem],
            [allDayItem, startDateItem, endDateItem],
            [repeatItem, calendarItem],
            [descriptionItem]
        ] as [[GroupItem]])
        
        
        // MARK: onValueChanged blocks
        
        allDayItem.onValueChanged = { state in
            let date = startDateItem.date
            self.eventQuery.allDay = state
            startDateItem.date = date.midnight
            endDateItem.date = date.tomorrow.midnight.seconds - 1
            if let indexPaths = self.indexPathsForItems([startDateItem, endDateItem] as [GroupItem]) {
                self.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
        
        startDateItem.onValueChanged = { [weak self] date in
            if let query = self?.eventQuery where !query.allDay {
                query.startDate = date
            }
        }
        endDateItem.onValueChanged = { [weak self] date in
            if let query = self?.eventQuery where !query.allDay {
                query.endDate = date
            }
        }
        
        // MARK: Validation
        
        startDateItem.validation = { date in
            if date >= NSDate().midnight {
                return nil
            }
            let message = NSLocalizedString("Cannot pick date earlier than today's midnight", comment: "")
            return NSError(message: message)
        }
        
        endDateItem.validation = { date in
            if date >= startDateItem.date {
                return nil
            }
            let message = NSLocalizedString("Cannot pick date earlier than", comment: "") + " " + startDateItem.dateString
            return NSError(message: message)
        }
    }
    
    private var eventQuery: EventQuery
}

// MARK: Date pickers handling

extension EditEventViewModel {
    
    func handleDateItemSelectionAtIndexPath(indexPath: NSIndexPath) {
        
        if let item = self[indexPath.section]?[indexPath.row] as? DateItem {
            
            var dateItems: [DateItem] = []
            let collapseIndexPaths = indexPathsForItemOfType(DatePickerItem.self)
            
            if let pickersIndexPaths = collapseIndexPaths {
                
                for pickerIndexPath in pickersIndexPaths {
                    removeItemAtIndexPath(pickerIndexPath)
                    if let dateItem = self[pickerIndexPath.section]?[pickerIndexPath.row-1] as? DateItem {
                        dateItem.selected = false
                        dateItems.append(dateItem)
                    }
                }
                
                delegate?.removedItemsAtIndexPaths(pickersIndexPaths)
                
                if let reloadIndexPaths = indexPathsForItems(dateItems) {
                    delegate?.didChangeItemsAtIndexPaths(reloadIndexPaths)
                }
            }
            
            if !item.selected && !contains(dateItems, item) {
                
                item.selected = true
                
                let pickerItem = DatePickerItem(date: item.date) { date in
                    if let error = item.validate(date) {
                        item.validationError = error
                    } else {
                        item.date = date
                        item.update()
                    }
                    
                    if let indexPaths = self.indexPathsForItems([item]) {
                        self.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                    }
                }
                
                if var currentIndexPath = indexPathsForItems([item])?.first {
                    currentIndexPath = NSIndexPath(forRow: currentIndexPath.row+1, inSection: currentIndexPath.section)
                    addItem(pickerItem, atIndexPath: currentIndexPath)
                    delegate?.addedItemsAtIndexPaths([currentIndexPath])
                }
            }
        }
    }
}

// MARK: Event saving

extension EditEventViewModel {
    
    func saveEvent(success: ResponseBlock, failure: ErrorBlock) {
        itemsUpdates()
        NetworkManager.sharedInstance.request(eventQuery, success: success, failure: failure)
    }
    
    private func itemsUpdates() {
        itemize {
            if let item = $0 as? Updatable {
                item.update()
            }
        }
    }
}
