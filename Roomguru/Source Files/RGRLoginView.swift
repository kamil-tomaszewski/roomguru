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
    
    func commonInit() {
        welcomeLabel.text = NSLocalizedString("Welcome to Roomguru! Sign in with Google+ to start using the app.", comment: "")
        welcomeLabel.accessibilityLabel = "Welcome to Roomguru!"
        welcomeLabel.textAlignment = .Center
        welcomeLabel.numberOfLines = 2
        
        addSubview(welcomeLabel)
        addSubview(signInButton)
        
        defineConstraints()
    }

    func defineConstraints() {
        layout(signInButton, welcomeLabel) { button, label in
            
            label.width == label.superview!.width
            label.top == label.superview!.top + 120
            
            button.width ==  (CGRectGetWidth(self.bounds) - 50) * 0.5
            button.height  == 50
            button.centerX == button.superview!.centerX
            button.bottom == button.superview!.bottom - 100
        }
    }
}
