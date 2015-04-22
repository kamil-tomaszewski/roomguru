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

protocol Presenter {
    func shouldPresentViewController(viewController: UIViewController)
}

class EditEventViewModel: GroupedListViewModel {
    
    var delegate: ModelUpdatable?
    var presenter: Presenter?
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
        rooms = CalendarPersistenceStore.sharedStore.rooms().map { RoomItem(room: $0) }

        let reccurenceItems = [
            RecurrenceItem(title: NSLocalizedString("Daily", comment: ""), recurrence: .Daily),
            RecurrenceItem(title: NSLocalizedString("Weekly", comment: ""), recurrence: .Weekly),
            RecurrenceItem(title: NSLocalizedString("Monthly", comment: ""), recurrence: .Monthly),
            RecurrenceItem(title: NSLocalizedString("Yearly", comment: ""), recurrence: .Yearly),
        ]
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
        let repeatItem = ActionItem(title: repeatTitle, detailDescription: noneDetail)
        let calendarItem = ActionItem(title: calendarTitle, detailDescription: noneDetail)
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
            
            let probableEndDate = date.minutes + 30
            if endDateItem.date < probableEndDate {
                endDateItem.date = probableEndDate
                if let indexPaths = self?.indexPathsForItems([endDateItem]) {
                    self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                }
            }
        }
        endDateItem.onValueChanged = { [weak self] date in
            if let query = self?.eventQuery where !query.allDay {
                query.endDate = date
            }
        }
        
        calendarItem.action = {
            let viewModel = ListViewModel(self.rooms) as ListViewModel<PickerItem>
            let controller = PickerViewController(viewModel: viewModel) { [weak self] item in
                if let item = item as? RoomItem {
                    calendarItem.detailDescription = item.name
                    self?.eventQuery.calendarID = item.id
                    
                    if let indexPaths = self?.indexPathsForItems([calendarItem]) {
                        self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                    }
                }
            }
            
            return controller
        }

        repeatItem.action = {
            let viewModel = ListViewModel(reccurenceItems) as ListViewModel<PickerItem>
            let controller = PickerViewController(viewModel: viewModel) { [weak self] item in
                if let item = item as? RecurrenceItem {
                    repeatItem.detailDescription = item.title
                    // NGRTodo: Implement recurrence parameter in eventQuery
                    // self?.eventQuery.recurrence = item.value
                    if let indexPaths = self?.indexPathsForItems([repeatItem]) {
                        self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                    }
                }
            }
            
            return controller
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
    private var rooms: [RoomItem]
}

// MARK: Date pickers handling

extension EditEventViewModel {
    
    func handleSelectionAtIndexPath(indexPath: NSIndexPath) {
        let item = self[indexPath.section]?[indexPath.row]

        if let item = item as? DateItem {
            handleSelectionOfDateItem(item, atIndexPath: indexPath)
        } else if let item = item as? ActionItem {
            handleSelectionOfActionItem(item, atIndexPath: indexPath)
        }
    }
    
    private func handleSelectionOfDateItem(item: DateItem, atIndexPath indexPath: NSIndexPath) {
            
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
    
    private func handleSelectionOfActionItem(item: ActionItem, atIndexPath indexPath: NSIndexPath) {
        if let controller = item.action?() {
            presenter?.shouldPresentViewController(controller)
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
            if let item = $1 as? Updatable {
                item.update()
            }
        }
    }
}
