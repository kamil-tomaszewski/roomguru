//
//  MaskingView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class MaskingView: UIView {
    
    var maskingView: UIView!
    var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView = UIView()
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 5
        contentView.backgroundColor = .clearColor()
        
        maskingView = UIView(frame: frame)
        maskingView.backgroundColor = .blackColor()
        maskingView.alpha = 1.0
        
        backgroundColor = .clearColor()
        
        addSubview(maskingView)
        addSubview(contentView)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(contentView) { content in
            let padding = self.frame.size.width * 0.1
            content.left == content.superview!.left + padding
            content.right == content.superview!.right - padding
            content.height == 250
            content.top == content.superview!.bottom
            content.centerX == content.superview!.centerX
        }
        
        layout(maskingView) { masking in
            masking.top == masking.superview!.top - 20
            masking.left == masking.superview!.left
            masking.right == masking.superview!.right
            masking.bottom == masking.superview!.bottom
        }
    }
}
