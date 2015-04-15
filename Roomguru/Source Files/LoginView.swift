//
//  LoginView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class LoginView: UIView {
    
    let signInButton = GPPSignInButton() as GPPSignInButton
    private var logoLabel = RoomguruLabel()
    let avatarView = AvatarView(frame: CGRectMake(0, 0, 100, 100))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.whiteColor()
        
        addSubview(logoLabel)
        addSubview(avatarView)
        
        signInButton.style = kGPPSignInButtonStyleWide
        signInButton.colorScheme = kGPPSignInButtonColorSchemeLight
        addSubview(signInButton)
        
        defineConstraints()
    }

    private func defineConstraints() {
        layout(signInButton, avatarView, logoLabel) { button, avatar, label in
            
            let margin: CGFloat = 20
            
            avatar.center == avatar.superview!.center
            avatar.width == CGRectGetWidth(self.avatarView.bounds)
            avatar.height == CGRectGetHeight(self.avatarView.bounds)
            
            label.left == label.superview!.left + margin
            label.right == label.superview!.right - margin
            label.bottom == avatar.top
            label.top == label.superview!.top
            
            button.width == button.superview!.width - 4 * margin
            button.height  == 45
            button.centerX == button.superview!.centerX
            button.bottom == button.superview!.bottom - 100
        }
    }
}
