//
//  SettingsTableHeaderView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SettingsTableHeaderView: UIImageView {
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
    private let avatarView = AvatarView(frame: CGRectMake(0, 0, 100, 100))
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        contentMode = .ScaleAspectFit
        image =  UserPersistenceStore.sharedStore.userImage()
        
        addSubview(visualEffectView)
                
        avatarView.imageView.image = image
        avatarView.setBorderVisible(false)
        addSubview(avatarView)

        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(visualEffectView, avatarView) { blurView, avatar in
            
            blurView.edges == blurView.superview!.edges
            
            avatar.center == avatar.superview!.center
            avatar.width == CGRectGetWidth(self.avatarView.bounds)
            avatar.height == CGRectGetHeight(self.avatarView.bounds)
        }
    }
}
