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
}
