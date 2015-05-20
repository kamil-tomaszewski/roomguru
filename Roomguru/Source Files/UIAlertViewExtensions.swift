//
//  UIAlertViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIAlertView {
    
    convenience init(error: NSError) {
        self.init(title: NSLocalizedString("Oh no!", comment: ""), message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
    }
    
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
    }
}

// MARK: Factory methods

extension UIAlertView {
    
    class func alertViewForBookedEvent(event: Event, inRoomNamed name: String) -> UIAlertView {
        
        let title = NSLocalizedString("Success", comment: "")
        let ending = " from " + event.startTime + " to " + event.endTime
        let declinedRooms = event.rooms.filter { $0.status == Status.NotGoing }

        var message: String!
        
        if declinedRooms.count > 0 {
            message = NSLocalizedString("Room", comment: "") + " " + name + NSLocalizedString("declined event", comment: "") + ending
        } else {
            message = NSLocalizedString("Booked room", comment: "") + " " + name + ending
        }
        
        return UIAlertView(title: title, message: message)
    }
}
