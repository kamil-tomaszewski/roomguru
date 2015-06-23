//
//  UIApplicationExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 01/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIApplication {
    
    class func openURLIfPossible(url: NSURL?, completion: (success: Bool, error: NSError?) -> Void) {
        
        if let url = url {
            if self.sharedApplication().canOpenURL(url) {
                self.sharedApplication().openURL(url)
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: NSError(message: "Couldn't open hangout link."))
            }
        } else {
            completion(success: false, error: NSError(message: "Link is broken."))
        }
    }
}
