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
        let width = CGRectGetWidth(self.frame)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, 160.0)
    }
    
    private func commonInit() {
        configureTextView()
        addSubview(textView)
        defineConstraints()
    }
    
    private func configureTextView() {
        textView.tintColor = UIColor.ngOrangeColor()
        textView.contentInset = UIEdgeInsetsMake(3, 7, 3, 7)
    }
    
    private func defineConstraints() {
        
        let width = CGRectGetWidth(self.frame)
        self.frame = CGRectMake(0, 0, width, 160.0)

        layout(textView) { text in
            text.edges == text.superview!.edges
            text.height == 160.0
        }
    }
}
