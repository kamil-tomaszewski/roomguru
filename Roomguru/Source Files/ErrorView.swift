//
//  ErrorView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class ErrorView: UIView {
    
    let textLabel = UILabel()
    let detailTextLabel = UILabel()
    let tapGestureRecognizer = UITapGestureRecognizer()
    
    init(frame: CGRect, target: AnyObject, action: Selector) {
        super.init(frame: frame)
        commonInit()
        tapGestureRecognizer.addTarget(target, action: action)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        addGestureRecognizer(tapGestureRecognizer)
        
        textLabel.text = "Something went wrong."
        textLabel.textAlignment = .Center
        addSubview(textLabel)
        
        detailTextLabel.text = "Tap to reload"
        detailTextLabel.textAlignment = .Center
        detailTextLabel.textColor = UIColor.grayColor()
        addSubview(detailTextLabel)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(textLabel, detailTextLabel) { textLabel, detailTextLabel in

            textLabel.top == textLabel.superview!.top
            textLabel.left == textLabel.superview!.left
            textLabel.right == textLabel.superview!.right
            textLabel.bottom == textLabel.superview!.centerY
            
            detailTextLabel.top == textLabel.superview!.top
            detailTextLabel.left == detailTextLabel.superview!.left
            detailTextLabel.right == textLabel.bottom
            detailTextLabel.bottom == textLabel.superview!.bottom
        }
    }
}
