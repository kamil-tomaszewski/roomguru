//
//  RGRLoginView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RGRLoginView: UIView {
    
    var signInButton = GPPSignInButton()
    var welcomeLabel = UILabel()
    
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
        
        welcomeLabel.text = NSLocalizedString("Welcome to Roomguru! Sign in with Google+ to start using the app.", comment: "")
        welcomeLabel.accessibilityLabel = "Welcome to Roomguru!"
        welcomeLabel.textAlignment = .Center
        welcomeLabel.numberOfLines = 0
        
        addSubview(welcomeLabel)
        addSubview(signInButton)
        
        defineConstraints()
    }

    private func defineConstraints() {
        layout(signInButton, welcomeLabel) { button, label in
            
            let margin: CGFloat = 20
            
            label.left == label.superview!.left + margin
            label.right == label.superview!.right - margin
            label.top == label.superview!.top + 120
            label.centerX == label.superview!.centerX
            
            button.width == button.superview!.width - 2 * margin
            button.height  == 45
            button.centerX == button.superview!.centerX
            button.bottom == button.superview!.bottom - 100
        }
    }
}
