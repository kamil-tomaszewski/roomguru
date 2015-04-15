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
    private let logoLabel = RoomguruLabel()
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    let avatarView = AvatarView(frame: CGRectMake(0, 0, 100, 100))
    
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
        
        addSubview(avatarView)
        addSubview(logoLabel)
        
        label.text = NSLocalizedString("Authenticating...", comment: "")
        label.textAlignment = .Center
        label.textColor = UIColor.ngOrangeColor()
        addSubview(label)
        
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.ngOrangeColor()
        addSubview(activityIndicator)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(label, avatarView, activityIndicator) { label, avatar, indicator in
            
            avatar.center == avatar.superview!.center
            avatar.width == CGRectGetWidth(self.avatarView.bounds)
            avatar.height == CGRectGetHeight(self.avatarView.bounds)
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.top == avatar.bottom + 20
            label.height == 30
            
            indicator.centerX == indicator.superview!.centerX
            indicator.centerY == label.bottom + 50
        }
        
        layout(logoLabel, avatarView) { label, avatar in
            
            label.left == label.superview!.left
            label.right == label.superview!.right
            label.bottom == avatar.top
            label.top == label.superview!.top
        }
    }
}
