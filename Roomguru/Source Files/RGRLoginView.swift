//
//  RGRLoginView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 11.03.2015.
//  Copyright (c) 2015 Patryk Kaczmarek. All rights reserved.
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
        welcomeLabel.text = "Some Text"
        welcomeLabel.textAlignment = .Center
        addSubview(signInButton)
        addSubview(welcomeLabel)
        
        defineConstraints()
    }

    func defineConstraints() {
        
        layout(signInButton, welcomeLabel) { button, label in
            
            button.width ==  (CGRectGetWidth(self.bounds) - 50) * 0.5
            button.height  == 50
            button.centerX == button.superview!.centerX
            button.centerY == button.superview!.centerY
            
            label.width == label.superview!.width
            label.top == label.superview!.top
            label.bottom == button.top
        }
    }
}
