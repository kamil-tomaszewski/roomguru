//
//  File.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func ngGrayColor() -> UIColor {
        return UIColor.rgb(39, 47, 61);
    }
    
    class func ngOrangeColor() -> UIColor {
        return UIColor.rgb(243, 166, 62);
    }
    
    class func ngRedColor() -> UIColor {
        return UIColor.rgb(237, 110, 102);
    }
    
    class func rgb(r: NSInteger, _ g: NSInteger, _ b: NSInteger) -> UIColor {
        return UIColor.rgba(r, g, b, 1)
    }
    
    class func rgba(r: NSInteger, _ g: NSInteger, _ b: NSInteger, _ a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
}
