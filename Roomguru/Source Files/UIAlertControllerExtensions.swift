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
}
