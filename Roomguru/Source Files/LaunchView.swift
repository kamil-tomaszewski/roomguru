//
//  LaunchView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 10/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class LaunchView: UIView {

    let label = UILabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
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
        
        backgroundColor = UIColor.ngGrayColor()
        
        label.text = "Authenticating..."
        label.textAlignment = .Center
        label.textColor = UIColor.ngOrangeColor()
        addSubview(label)
        
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.ngOrangeColor()
        addSubview(activityIndicator)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(label, activityIndicator) { label, indicator in
            
            indicator.center == indicator.superview!.center
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.bottom == indicator.top
            label.height == 30
        }
    }
}
