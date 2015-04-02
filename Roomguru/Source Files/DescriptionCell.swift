//
//  DescriptionCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DescriptionCell: UITableViewCell {
    
    private struct constants { static var cellIdentifier: String = "TableViewDescriptionCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return constants.cellIdentifier }
        set { constants.cellIdentifier = newValue }
    }
    
    class func margins() -> (H: CGFloat, V: CGFloat) {
        return (20, 5);
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // DISCLAIMER: When using cartography and autolayout
        // boundingRectWithSize:options:context: method doesn't calculate height properly.
        
        let margins = DescriptionCell.margins()
        textLabel?.frame = CGRectInset(self.bounds, margins.H, margins.V)
    }
    
    
    private func commonInit() {
        textLabel?.numberOfLines = 0
    }
}
