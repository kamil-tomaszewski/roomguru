//
//  TextViewCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class TextViewCell: UITableViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "TableViewTextViewCellReuseIdentifier"
    }
    
    let textView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let originX = CGRectGetMinX(frame)
        let originY = CGRectGetMinY(frame)
        let width = CGRectGetWidth(frame)
        let height = CGFloat(160.0)
        
        frame = CGRectMake(originX, originY, width, height)
    }
}

private extension TextViewCell {
    
    func commonInit() {
        configureTextView(textView)
        addSubview(textView)
        defineConstraints()
    }
    
    func configureTextView(textView: UITextView) {
        textView.scrollEnabled = false
        textView.tintColor = .ngOrangeColor()
        textView.contentInset = UIEdgeInsetsMake(3, 7, 3, 7)
    }
    
    func defineConstraints() {
        
        let width = CGRectGetWidth(self.frame)
        self.frame = CGRectMake(0, 0, width, 160.0)
        
        layout(textView) { text in
            text.edges == text.superview!.edges
            text.height == 160.0
        }
    }
}
