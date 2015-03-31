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
        
        if let _url = url {
            if self.sharedApplication().canOpenURL(_url) {
                self.sharedApplication().openURL(_url)
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: NSError(message: "Couldn't open hangout link."))
            }
        } else {
            completion(success: false, error: NSError(message: "Hangout link is broken."))
        }
    }
}
