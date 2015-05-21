//
//  DateCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 17/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class DateCell: UITableViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "TableViewDateCellReuseIdentifier"
    }
    
    let dateLabel = UILabel()
    var shouldBeGreyedOut = false {
        didSet {
            let color: UIColor = shouldBeGreyedOut ? .lightGrayColor() : .blackColor()
            dateLabel.textColor = color
        }
    }
    
    private var textAttributes = [NSObject: AnyObject]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected && !shouldBeGreyedOut {
            toggleLabelColor()
        }
    }
    
    func setDateText(text: String, withValidationError error: NSError? = nil) {
        let strikethroughStyle: NSUnderlineStyle = (error != nil) ? .StyleSingle : .StyleNone
        textAttributes[NSStrikethroughStyleAttributeName] = strikethroughStyle.rawValue
        setDateLabelText(text, withAttributes: textAttributes)
    }
    
    func setHighlightedLabelColor(selected: Bool) {
        let color: UIColor = selected ? .ngOrangeColor() : shouldBeGreyedOut ? .lightGrayColor() : .blackColor()
        setLabelColor(color)
    }
}

private extension DateCell {
    
    func commonInit() {
        dateLabel.text = ""
        dateLabel.textAlignment = .Right
        contentView.addSubview(dateLabel)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(dateLabel) { date in
            
            date.right == date.superview!.right - 15
            date.left == date.superview!.left
            date.height == 44.0
        }
    }
    
    func setDateLabelText(text: String, withAttributes attributes: [NSObject: AnyObject]) {
        dateLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    func toggleLabelColor() {
        let blackColor = UIColor.blackColor()
        let color = dateLabel.textColor == blackColor ? .ngOrangeColor() : blackColor
        setLabelColor(color)
    }
    
    func setLabelColor(color: UIColor) {
        textAttributes[NSForegroundColorAttributeName] = color
        setDateLabelText(dateLabel.text!, withAttributes: textAttributes)
    }
    
}
