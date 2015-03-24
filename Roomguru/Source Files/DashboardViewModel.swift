//
//  DashboardViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

struct CellItem {
    
    let title: NSString
    let target: AnyObject?
    let action: NSString
    let identifier : Identifier
    
    enum Identifier {
        case RevokeEvent, BookRoom
    }
}

class DashboardViewModel: NSObject {
    
    var items: [CellItem] = []
    
    // MARK: Public Methods
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    // MARK: Actions
    
    func revokeEvent() {
        println("revokeEvent")
    }
    
    func bookRoom() {
        let bookingManager = BookingManager()
        
        bookingManager.bookTheClosestAvailableRoom({ (response) -> () in
            
            }, failure: { (error) -> () in
                println(error)
        })
    }
}
