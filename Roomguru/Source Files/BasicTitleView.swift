//
//  BasicTitleView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 10/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class BasicTitleView: UIView {
    
    var textLabel: UILabel = UILabel()
    var detailTextLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        configureLabels()
        addSubview(textLabel)
        addSubview(detailTextLabel)
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(textLabel, detailTextLabel) { text, detail in
            text.top == text.superview!.top + 7
            text.left == text.superview!.left
            text.right == text.superview!.right
            text.height == 16
            
            detail.top == text.bottom
            detail.left == detail.superview!.left
            detail.right == detail.superview!.right
            detail.height == text.height
        }
    }
    
    func configureLabels() {
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.boldSystemFontOfSize(17)
        textLabel.textColor = UIColor.ngOrangeColor()
        
        detailTextLabel.textAlignment = .Center
        detailTextLabel.font = UIFont.systemFontOfSize(12)
        detailTextLabel.textColor = UIColor.ngOrangeColor()
    }
}
