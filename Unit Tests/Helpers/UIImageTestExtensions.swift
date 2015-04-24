//
//  UIImageTestExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIImage {
    
    class func composeImageWithSize(size: CGSize, color: UIColor) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, CGRect(origin: CGPointZero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    class func composeTestImage() -> UIImage {
        return composeImageWithSize(CGSizeMake(20, 20), color: UIColor.redColor())
    }
}

