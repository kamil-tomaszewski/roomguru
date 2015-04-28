//
//  NSAttributedStringExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    func boundingHeightUsingAvailableWidth(width: CGFloat) -> CGFloat {
        
        let options = unsafeBitCast(
            NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue,
            NSStringDrawingOptions.self
        )
        return ceil(boundingRectWithSize(CGSizeMake(width, CGFloat(MAXFLOAT)), options:options, context:nil).size.height)
    }
}
