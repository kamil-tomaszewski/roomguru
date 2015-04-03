//
//  LoadingView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class LoadingView: UIView {
    
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
        
        backgroundColor = UIColor.whiteColor()
        
        label.text = "Loading..."
        label.textAlignment = .Center
        label.textColor = UIColor.ngGrayColor()
        addSubview(label)
        
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.ngGrayColor()
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
