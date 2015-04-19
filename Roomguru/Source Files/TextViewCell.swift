//
//  TextViewCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class TextViewCell: TableViewCell {
    
    private struct Constants { static var CellIdentifier: String = "TableViewTextViewCellReuseIdentifier"}
    
    override class var reuseIdentifier: String {
        get { return Constants.CellIdentifier }
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
    
    private func commonInit() {
        let width = CGRectGetWidth(self.frame)
        self.frame = CGRectMake(0, 0, width, 160.0)
        
        configureTextView()
        addSubview(textView)
        defineConstraints()
    }
    
    private func configureTextView() {
        textView.tintColor = UIColor.ngOrangeColor()
        textView.contentInset = UIEdgeInsetsMake(3, 7, 3, 7)
    }
    
    private func defineConstraints() {
        
        layout(textView) { text in
            text.edges == text.superview!.edges
            text.height == 160.0
        }
    }
}
