//
//  BookingManager.swift
//  Roomguru
//
//  Created by Pawel Bialecki on 23.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class BookingManager: NSObject {
    
    func bookTheClosestAvailableRoom(success: ResponseBlock, failure: ErrorBlock) {
        
        let allRooms = [Room.Test, Room.Aqua]
        
        NetworkManager.sharedInstance.freebusyList(allRooms, success: { (response: JSON?) -> () in
            
            let calendarsDictionary: Dictionary<String, JSON> = response!["calendars"].dictionaryValue
            
        }, failure: { (error: NSError) -> () in
            println(error)
        })
        
    }
    
}
