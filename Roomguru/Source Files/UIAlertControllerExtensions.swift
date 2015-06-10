//
//  UIAlertControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 22/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation


extension UIAlertController {
    
    class func destroyAlertControllerWithTitle(title: String, message: String, destroyHandler: VoidBlock) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive) { (action) in
            destroyHandler()
        }
        alertController.addAction(destroyAction)
        
        return alertController
    }
    
    convenience init(error: NSError) {
        self.init(title: NSLocalizedString("Oh no!", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
        
        addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .Alert)
        
        addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    convenience init(message: String) {
        self.init(title: NSLocalizedString("Oh no!", comment: ""), message: message)
    }
}

// MARK: Factory methods

extension UIAlertController {
    
    class func alertControllerForBookedEvent(event: Event, inRoomNamed name: String) -> UIAlertController {
        
        let title = NSLocalizedString("Success", comment: "")
        let ending = " from " + event.startTime + " to " + event.endTime
        let declinedRooms = event.rooms.filter { $0.status == Status.NotGoing }
        
        var message: String!
        
        if declinedRooms.count > 0 {
            message = NSLocalizedString("Room", comment: "") + " " + name + NSLocalizedString("declined event", comment: "") + ending
        } else {
            message = NSLocalizedString("Booked room", comment: "") + " " + name + ending
        }
        
        return self.init(title: title, message: message)
    }
}
