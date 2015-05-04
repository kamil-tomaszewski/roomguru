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
    
    private(set) var calendars: [Calendar] = []
    
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
    
    func saveCalendars(calendars: [Calendar]) {
        let dataRepresentation = NSKeyedArchiver.archivedDataWithRootObject(calendars)
        Defaults[key()] = dataRepresentation
        Defaults.synchronize()
        
        self.calendars = calendars
        NSNotificationCenter.defaultCenter().postNotificationName(CalendarPersistentStoreDidChangePersistentCalendars, object: nil)
    }
    
    func clear() {
        Defaults.remove(key())
        Defaults.synchronize()
        
        calendars = []
        NSNotificationCenter.defaultCenter().postNotificationName(CalendarPersistentStoreDidChangePersistentCalendars, object: nil)
    }
}

private extension CalendarPersistenceStore {
    
    func key() -> String {
        let user = UserPersistenceStore.sharedStore.user
        return user?.email.lowercaseString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).md5() ?? "DefaultUserCalendarPersistenceKey"
    }
    
    func fetch() -> [Calendar]? {
        if let data = Defaults[key()].data {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Calendar]
        }
        return nil
    }
}
