//
//  File.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UIColor {
    
    class func ngBarTranslucentGrayColor() -> UIColor {
        return .rgb(39, 47, 61)
    }
    
    class func ngGrayColor() -> UIColor {
        return .rgb(69, 76, 87)
    }
    
    class func ngOrangeColor() -> UIColor {
        return .rgb(243, 166, 62)
    }
    
    class func ngRedColor() -> UIColor {
        return .rgb(237, 110, 102)
    }
    
    class func systemPlaceholder() -> UIColor {
        return .rgb(199, 199, 205)
    }
    
    class func rgb(r: NSInteger, _ g: NSInteger, _ b: NSInteger) -> UIColor {
        return .rgba(r, g, b, 1)
    }
    
    class func rgba(r: NSInteger, _ g: NSInteger, _ b: NSInteger, _ a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
    }
}
