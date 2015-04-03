//
//  EmptyView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EmptyView: UIView {
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        
        label.text = "No Content."
        label.textAlignment = .Center
        label.textColor = UIColor.ngGrayColor()
        addSubview(label)

        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(label) { label in
            label.edges == label.superview!.edges; return
        }
    }
}
