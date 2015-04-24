//
//  NSDataTestExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension NSData {
    
    class func composeTestImagaDataRepresentation() -> NSData {
        return UIImagePNGRepresentation(UIImage.composeTestImage());
    }
}
