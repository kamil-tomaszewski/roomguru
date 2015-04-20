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
    func dataChangedInItems(items: [GroupItem])
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
            self.delegate?.dataChangedInItems([startDateItem, endDateItem] as [GroupItem])
        }
        
        startDateItem.onValueChanged = { [weak self] in self?.eventQuery.startDate = $0 }
        endDateItem.onValueChanged = { [weak self] in self?.eventQuery.endDate = $0 }
        
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
