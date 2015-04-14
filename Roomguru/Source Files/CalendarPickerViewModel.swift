//
//  CalendarPickerViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 02/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class CalendarPickerViewModel {

    private var calendars: [(isSelected: Bool, calendar: Calendar)]
    
    init(calendars: [Calendar]) {
        self.calendars = calendars.filter { $0.isResource() }.map {
            let selected = CalendarPersistenceStore.sharedStore.isCalendarPersisted($0)
            return (isSelected: selected, calendar: $0)
        }
    }
    
    // MARK: Public
    
    func selectOrDeselectCalendarAtIndex(index: Int) {
        let selected = calendars[index].isSelected
        calendars[index].isSelected = !selected
    }
    
    func shouldSelectCalendarAtIndex(index: Int) -> Bool {
        return calendars[index].isSelected
    }
    
    func shouldProcceed() -> Bool {
        return !self.calendars.filter { $0.isSelected }.isEmpty
    }
    
    func count() -> Int {
        return calendars.count
    }
    
    func saveNameForCalendarAtIndexWithSelection(index: Int, name: String?) {
        calendars[index].isSelected = true
        calendars[index].calendar.name = name
    }
    
    func save() {
        let array = calendars.filter{ $0.isSelected }.map { $0.calendar }
        CalendarPersistenceStore.sharedStore.saveCalendars(array)
    }
    
    func resetCustomCalendarNameAtIndex(index: Int) {
        calendars[index].calendar.name = nil
    }
    
    func hasCalendarAtIndexCustomizedName(index: Int) -> Bool {
        return calendars[index].calendar.name != nil
    }
    
    func textForCalendarAtIndex(index: Int) -> (mainText: String?, detailText: String?) {
        
        let picker = calendars[index]
        
        let placeholder = NSLocalizedString("Not changed", comment: "")
        let mainText = picker.calendar.name ?? picker.calendar.summary
        var detailText = (picker.calendar.name != nil) ? picker.calendar.summary : placeholder
        
        if (detailText != nil) && (detailText != placeholder) {
            detailText = NSLocalizedString("was: ", comment: "") + detailText!
        }
        return (mainText, detailText)
    }
}
