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

    private let label = UILabel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let avatarImageView = RoundBorderedImageView(frame: CGRectMake(0, 0, 100, 100))
    
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
        
        addSubview(avatarImageView)
        
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
        
        layout(label, avatarImageView, activityIndicator) { label, imageView, indicator in
            
            imageView.centerY == imageView.superview!.bottom - 400
            imageView.centerX == imageView.superview!.centerX
            imageView.width == CGRectGetWidth(self.avatarImageView.bounds)
            imageView.height == CGRectGetHeight(self.avatarImageView.bounds)
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.top == imageView.bottom + 20
            label.height == 30
            
            indicator.centerX == indicator.superview!.centerX
            indicator.centerY == label.bottom + 100
        }
    }
}
