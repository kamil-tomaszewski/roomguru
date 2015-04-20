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

        if selected {
            toggleLabelColor()
        }
    }
    
    func setSelectedLabelColor(selected: Bool) {
        let color = selected ? UIColor.ngOrangeColor() : UIColor.blackColor()
        setLabelColor(color)
    }
        
    // MARK: Private
    
    private func commonInit() {
        dateLabel.textAlignment = .Right
        addSubview(dateLabel)
        defineConstraints()
    }
    
    private func defineConstraints() {

        let margin: CGFloat = 15
        
        layout(dateLabel) { (date) in

            date.right == date.superview!.right - margin
            date.left == date.superview!.left
            date.height == 44.0
        }
    }
    
    private func toggleLabelColor() {
        let blackColor = UIColor.blackColor()
        let color = dateLabel.textColor == blackColor ? UIColor.ngOrangeColor() : blackColor
        setLabelColor(color)
    }
    
    private func setLabelColor(color: UIColor) {
        dateLabel.textColor = color
    }
}
