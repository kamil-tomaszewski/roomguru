//
//  SettingsCollectionViewHeader.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SettingsCollectionViewHeader: UICollectionReusableView, Reusable {

    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
    private let avatarView = AvatarView(frame: CGRectMake(0, 0, 110, 110))
    private let backgroundImageView = UIImageView()
    
    class func reuseIdentifier() -> String {
        return "SettingsCollectionViewHeaderReuseIdentifier"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension SettingsCollectionViewHeader {
    
    func commonInit() {
        
        clipsToBounds = true
        backgroundColor = .whiteColor()
        
        backgroundImageView.contentMode = .ScaleAspectFit
        backgroundImageView.image =  UserPersistenceStore.sharedStore.userImage()
        backgroundImageView.clipsToBounds = true
        
        addSubview(backgroundImageView)
        backgroundImageView.addSubview(visualEffectView)
        
        avatarView.imageView.image = backgroundImageView.image
        avatarView.setBorderVisible(false)
        addSubview(avatarView)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(visualEffectView, avatarView, backgroundImageView) { blurView, avatar, imageView in
            
            imageView.top == imageView.superview!.top - 20
            imageView.left == imageView.superview!.left - 20
            imageView.bottom == imageView.superview!.bottom + 20
            imageView.right == imageView.superview!.right + 20
            
            blurView.edges == imageView.edges
            
            avatar.center == avatar.superview!.center
            avatar.width == CGRectGetWidth(self.avatarView.bounds)
            avatar.height == CGRectGetHeight(self.avatarView.bounds)
        }
    }
    
}
