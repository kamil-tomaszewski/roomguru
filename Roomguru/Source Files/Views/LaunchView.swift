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

    let statusLabel = UILabel()
    let logoLabel = RoomguruLabel()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let avatarView = AvatarView(frame: CGRectMake(0, 0, 100, 100))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
        backgroundColor = .whiteColor()
        
        addSubview(avatarView)
        addSubview(logoLabel)
        
        statusLabel.text = NSLocalizedString("Authenticating...", comment: "")
        statusLabel.textAlignment = .Center
        statusLabel.textColor = .ngOrangeColor()
        addSubview(statusLabel)
        
        activityIndicator.startAnimating()
        activityIndicator.color = .ngOrangeColor()
        addSubview(activityIndicator)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(statusLabel, avatarView, activityIndicator) { label, avatar, indicator in
            
            avatar.center == avatar.superview!.center
            avatar.width == CGRectGetWidth(self.avatarView.bounds)
            avatar.height == CGRectGetHeight(self.avatarView.bounds)
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.top == avatar.bottom + 20
            label.height == 30
            
            indicator.centerX == indicator.superview!.centerX
            indicator.centerY == label.bottom + 80
        }
        
        layout(logoLabel, avatarView) { label, avatar in
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.bottom == avatar.top
            label.top == label.superview!.top
        }
    }
}
