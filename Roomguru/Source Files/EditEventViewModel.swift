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
    func presentViewController(viewController: UIViewController)
}

class EditEventViewModel<T: GroupItem>: GroupedListViewModel<GroupItem> {
    
    let networkCooperator: EditEventNetworkCooperator
    private var rooms: [RoomItem]
    
    var delegate: ModelUpdatable?
    var presenter: Presenter?
    var title: String
    
    init(calendarEntry: CalendarEntry?) {
        
        let query: EventQuery
        
        if let calendarEntry = calendarEntry {
            title = NSLocalizedString("New Event", comment: "")
            query = EventQuery(calendarEntry: calendarEntry)
        } else {
            title = NSLocalizedString("Edit Event", comment: "")
            query = EventQuery()
        }
        networkCooperator = EditEventNetworkCooperator(query: query)
        rooms = CalendarPersistenceStore.sharedStore.rooms().map { RoomItem(room: $0) }

        let reccurenceItems = [
            RecurrenceItem(title: NSLocalizedString("None", comment: ""), recurrence: .None, selected: true),
            RecurrenceItem(title: NSLocalizedString("Daily", comment: ""), recurrence: .Daily),
            RecurrenceItem(title: NSLocalizedString("Weekly", comment: ""), recurrence: .Weekly),
            RecurrenceItem(title: NSLocalizedString("Monthly", comment: ""), recurrence: .Monthly),
            RecurrenceItem(title: NSLocalizedString("Yearly", comment: ""), recurrence: .Yearly),
        ]
        // MARK: Parameters
        
        let summaryPlaceholder = NSLocalizedString("Summary (min. 5 characters)", comment: "")
        let allDayTitle = NSLocalizedString("All-day", comment: "")
        let startDateTitle = NSLocalizedString("Starts", comment: "")
        let endDateTitle = NSLocalizedString("Ends", comment: "")
        let repeatTitle = NSLocalizedString("Repeat", comment: "")
        let noneDetail = NSLocalizedString("None", comment: "")
        let calendarTitle = NSLocalizedString("Room", comment: "")
        let longTextPlaceholder = NSLocalizedString("Description", comment: "")
        
        // MARK: Create items
        
        let summaryItem = TextItem(placeholder: summaryPlaceholder)
        let allDayItem = SwitchItem(title: allDayTitle)
        let startDateItem = DateItem(title: startDateTitle)
        let endDateItem = DateItem(title: endDateTitle, date: startDateItem.date.minutes + 30)
        let repeatItem = ActionItem(title: repeatTitle, detailDescription: noneDetail)
        let calendarItem = ResultActionItem(title: calendarTitle, detailDescription: noneDetail)
        let descriptionItem = LongTextItem(placeholder: longTextPlaceholder)
        
        // MARK: Fill items
        
        summaryItem.text = networkCooperator.eventQuery.summary
        allDayItem.on = networkCooperator.eventQuery.allDay

        if let startDate = networkCooperator.eventQuery.startDate {
            startDateItem.date = startDate
        }

        if let endDate = networkCooperator.eventQuery.endDate {
            endDateItem.date = endDate
        }
        
        repeatItem.detailDescription = networkCooperator.eventQuery.recurrence?.lowercaseString.uppercaseFirstLetter ?? ""

        let calendarName = CalendarPersistenceStore.sharedStore.nameMatchingID(networkCooperator.eventQuery.calendarID)
        let room = CalendarPersistenceStore.sharedStore.rooms().filter { $0.id == query.calendarID }.map { RoomItem(room: $0) }.first
        
        if let room = room {
            calendarItem.result = room
            calendarItem.detailDescription = room.title
        }
        
        descriptionItem.text = networkCooperator.eventQuery.eventDescription
        
        // MARK: Super init
        
        super.init(items: [
            [summaryItem],
            [allDayItem, startDateItem, endDateItem],
            [repeatItem, calendarItem],
            [descriptionItem]
        ] as [[GroupItem]])
        
        
        // MARK: onValueChanged blocks
        
        summaryItem.onValueChanged = { [weak self] text in
            self?.networkCooperator.eventQuery.summary = text
            
            if let indexPaths = self?.indexPathsForItems([summaryItem] as [GroupItem]) {
                self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }

        allDayItem.onValueChanged = { [weak self] state in
            
            self?.networkCooperator.eventQuery.allDay = state
            var date: NSDate!
            
            if state {
                date = startDateItem.date
                startDateItem.date = date.midnight.second(59).date
                endDateItem.date = date.tomorrow.midnight.seconds - 1
            } else {
                date = NSDate().minutes + 1
                startDateItem.date = date
                endDateItem.date = date.minutes + 30
            }
            
            self?.networkCooperator.eventQuery.startDate = startDateItem.date
            self?.networkCooperator.eventQuery.endDate = endDateItem.date
            
            func togglePickerForDateItem(item: DateItem) {
                if item.highlighted {
                    let indexPath = self?.indexPathsForItems([item])?.first
                    
                    if let indexPath = indexPath {
                        let nextIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
                        
                        if state {
                            self?.removeAtIndexPath(nextIndexPath)
                            self?.delegate?.removedItemsAtIndexPaths([nextIndexPath])
                        } else {
                            if let pickerItem = self?.datePickerItemForDateItem(item) {
                                self?.addItem(pickerItem, atIndexPath: nextIndexPath)
                                self?.delegate?.addedItemsAtIndexPaths([nextIndexPath])
                            }
                        }
                    }
                }
            }
            
            togglePickerForDateItem(startDateItem)
            togglePickerForDateItem(endDateItem)
            
            startDateItem.active = !state
            endDateItem.active = !state
            
            if let indexPaths = self?.indexPathsForItems([startDateItem, endDateItem] as [GroupItem]) {
                self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
        
        startDateItem.onValueChanged = { [weak self] date in
            if let query = self?.networkCooperator.eventQuery where !query.allDay {
                query.startDate = date
            }
            
            let probableEndDate = date.minutes + Int(Constants.Timeline.MinimumEventDuration/60)
            if endDateItem.date < probableEndDate {
                endDateItem.date = probableEndDate
            }

            if let indexPaths = self?.indexPathsForItems([endDateItem]) {
                self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
        
        endDateItem.onValueChanged = { [weak self] date in
            if let query = self?.networkCooperator.eventQuery where !query.allDay {
                query.endDate = date
            }
        }
        
        calendarItem.action = {
            let viewModel = ListViewModel(self.rooms) as ListViewModel<PickerItem>
            let controller = PickerViewController(viewModel: viewModel) { [weak self] item in
                if let item = item as? RoomItem {
                    calendarItem.detailDescription = item.title
                    calendarItem.result = item.id
                    self?.networkCooperator.eventQuery.calendarID = item.id
                    
                    if let indexPaths = self?.indexPathsForItems([calendarItem]) {
                        self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                    }
                }
            }
            controller.title = NSLocalizedString("Select room", comment: "")
            return controller
        }

        repeatItem.action = {
            let viewModel = ListViewModel(reccurenceItems) as ListViewModel<PickerItem>
            let controller = PickerViewController(viewModel: viewModel) { [weak self] item in
                if let item = item as? RecurrenceItem {
                    repeatItem.detailDescription = item.title
                    self?.networkCooperator.eventQuery.recurrence = item.value

                    if let indexPaths = self?.indexPathsForItems([repeatItem]) {
                        self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
                    }
                }
            }
            controller.title = NSLocalizedString("Repeat event", comment: "")
            return controller
        }
        
        descriptionItem.onValueChanged = { [weak self] description in
            self?.networkCooperator.eventQuery.eventDescription = description
        }
        
        // MARK: Validation
        
        summaryItem.validation = { string in
            if string.length < 5 {
                let message = NSLocalizedString("Summary should have at least 5 characters", comment: "")
                return NSError(message: message)
            }
            return nil
        }
        
        startDateItem.validation = { date in
            if date < NSDate().midnight {
                let message = NSLocalizedString("Cannot pick date earlier than today's midnight", comment: "")
                return NSError(message: message)
                
            } else if endDateItem.date.timeIntervalSinceDate(date) < Constants.Timeline.MinimumEventDuration {
                let message = NSLocalizedString("Cannot create event shorter than \(Constants.Timeline.MinimumEventDuration/60) minutes", comment: "")
                return NSError(message: message)
            }
            return nil
        }
        
        endDateItem.validation = { date in
            
            let calendarUnits: [NSCalendarUnit] = [.CalendarUnitYear, .CalendarUnitMonth, .CalendarUnitDay, .CalendarUnitHour, .CalendarUnitMinute]
            let comparisonResult = date.compare(toDate: startDateItem.date, byUnits: calendarUnits)
            
            if comparisonResult.notDescending {
                let reason = comparisonResult.ascending ? NSLocalizedString("date earlier than", comment: "") : NSLocalizedString("same date as", comment: "")
                let message = NSLocalizedString("Cannot pick", comment: "") + " " + reason + " " + startDateItem.dateString
                return NSError(message: message)
            }
            return nil
        }
        
        calendarItem.validation = { object in
            if let string = object as? String where string.isEmpty {
                let message = NSLocalizedString("Please choose room", comment: "")
                return NSError(message: message)
            }
            return nil
        }
    }
}

// MARK: Date pickers handling

extension EditEventViewModel {
    
    func handleSelectionAtIndexPath(indexPath: NSIndexPath) {
        let item = self[indexPath.section][indexPath.row]

        if let item = item as? DateItem {
            handleSelectionOfDateItem(item, atIndexPath: indexPath)
        } else if let item = item as? ActionItem {
            handleSelectionOfActionItem(item, atIndexPath: indexPath)
        }
    }
    
    private func handleSelectionOfDateItem(item: DateItem, atIndexPath indexPath: NSIndexPath) {
            
        if networkCooperator.eventQuery.allDay {
            return
        }
        
        var dateItems: [DateItem] = []
        let collapseIndexPaths = indexPathsForItemOfType(DatePickerItem.self)
        
        if let pickersIndexPaths = collapseIndexPaths {
            
            for pickerIndexPath in pickersIndexPaths {

                let section = pickerIndexPath.section
                let row = pickerIndexPath.row
                
                if let pickerItem = self[section][row] as? DatePickerItem {
                    pickerItem.unbindDatePicker()
                }

                removeAtIndexPath(pickerIndexPath)
                
                if let dateItem = self[section][row-1] as? DateItem {
                    dateItem.highlighted = false
                    dateItems.append(dateItem)
                }
            }
            
            delegate?.removedItemsAtIndexPaths(pickersIndexPaths)
            
            if let reloadIndexPaths = indexPathsForItems(dateItems) {
                delegate?.didChangeItemsAtIndexPaths(reloadIndexPaths)
            }
        }
        
        if !item.highlighted && !contains(dateItems, item) {
            
            item.highlighted = true
            
            let pickerItem = datePickerItemForDateItem(item)
            
            if var currentIndexPath = indexPathsForItems([item])?.first {
                currentIndexPath = NSIndexPath(forRow: currentIndexPath.row+1, inSection: currentIndexPath.section)
                addItem(pickerItem, atIndexPath: currentIndexPath)
                delegate?.addedItemsAtIndexPaths([currentIndexPath])
            }
        }
    }
    
    private func handleSelectionOfActionItem(item: ActionItem, atIndexPath indexPath: NSIndexPath) {
        if let controller = item.action?() {
            presenter?.presentViewController(controller)
        }
    }
    
    private func datePickerItemForDateItem(item: DateItem) -> DatePickerItem {
        return DatePickerItem(date: item.date) { [weak self] date in
            item.date = date
            item.update()
            
            if let indexPaths = self?.indexPathsForItems([item]) {
                self?.delegate?.didChangeItemsAtIndexPaths(indexPaths)
            }
        }
    }
}

// MARK: First responder

extension EditEventViewModel {
    
    func resignFirstResponderOnItems() {
        itemize { path, item in
            if let item = item as? TextItem {
                item.shouldBeFirstResponder = false
            }
        }
    }
}

// MARK: Validation

extension EditEventViewModel {
    
    func isModelValid() -> NSError? {
        var reloadIndexPaths: [NSIndexPath] = []
        var errors: [NSError] = []
        
        updateItems()
        
        itemize { (path, item) in
            if var item = item as? Validatable {
                if let error = item.validationError {
                    errors.append(error)
                }
                reloadIndexPaths.append(NSIndexPath(forRow: path.row, inSection: path.section))
            }
        }
        
        delegate?.didChangeItemsAtIndexPaths(reloadIndexPaths)
        return errors.first
    }
}

extension EditEventViewModel {
    
    private func updateItems() {
        itemize {
            if let item = $1 as? Updatable {
                item.update()
            }
        }
    }
}
