//
//  CalendarPersistenceStore.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import CryptoSwift

class CalendarPersistenceStore {
    
    class var sharedStore: CalendarPersistenceStore {
        struct Static {
            static let instance: CalendarPersistenceStore = CalendarPersistenceStore()
        }
        return Static.instance
    }
    
    var calendars: [Calendar] = []
    
    init() {
        calendars = fetch() ?? []
    }
    
    func rooms() -> [(name: String, id: String)] {
        return calendars.filter{ $0.summary != nil && $0.identifier != nil }.map{ (name: $0.name ?? $0.summary!, id: $0.identifier!) }
    }
    
    func matchingCalendar(calendar: Calendar) -> Calendar? {
        return calendars.filter{ $0 == calendar }.first
    }
    
    func isCalendarPersisted(calendar: Calendar) -> Bool {
        return matchingCalendar(calendar) != nil
    }
    
    // MARK: Saving and Reading
    
    func saveCalendars(calendars: [Calendar]) {
        if let _key = key() {
            let dataRepresentation = NSKeyedArchiver.archivedDataWithRootObject(calendars)
            Defaults[_key] = dataRepresentation
            Defaults.synchronize()
        }
        self.calendars = calendars
    }
    
    func fetch() -> [Calendar]? {
        if let let _key = key(), data = Defaults[_key].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Calendar]
        }
        return nil
    }
    
    func clear() {
        if let _key = key() {
            Defaults.remove(_key)
            Defaults.synchronize()
        }
    }
    
    private func key() -> String? {
        let user = UserPersistenceStore.sharedStore.user
        return user?.email.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).md5()
    }
}
