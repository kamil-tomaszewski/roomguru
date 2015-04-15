//
//  AttendeeCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class AttendeeCell: UITableViewCell {
    
    let statusLabel = UILabel()
    let headerLabel = UILabel()
    let footerLabel = UILabel()
    let avatarView = AvatarView(frame: CGRectMake(0, 0, 40, 40))
    
    private struct Constants { static var CellIdentifier: String = "TableViewAttendeeCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return Constants.CellIdentifier }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.imageView.image = nil
        statusLabel.text = nil
    }
    
    // MARK: Private
    
    private func commonInit() {
        
        headerLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(headerLabel)
        
        footerLabel.textColor = UIColor.darkGrayColor()
        footerLabel.font = UIFont.systemFontOfSize(12)
        contentView.addSubview(footerLabel)
        
        statusLabel.font = UIFont.fontAwesomeOfSize(20)
        statusLabel.textColor = UIColor.ngOrangeColor()
        statusLabel.textAlignment = .Center
        contentView.addSubview(statusLabel)
        
        avatarView.imageView.layer.borderWidth = 2
        contentView.addSubview(avatarView)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(avatarView, statusLabel, headerLabel) { avatar, rightLabel, topLabel in
            
            let margins: (H: CGFloat, V: CGFloat) = (15, 10)
            
            avatar.centerY == avatar.superview!.centerY
            avatar.left == rightLabel.superview!.left + margins.H
            avatar.width == CGRectGetWidth(self.avatarView.frame)
            avatar.height == CGRectGetHeight(self.avatarView.frame)
            
            rightLabel.top == rightLabel.superview!.top + margins.V
            rightLabel.bottom == rightLabel.superview!.bottom - margins.V
            rightLabel.right == rightLabel.superview!.right - margins.H
            rightLabel.width == 30
            
            topLabel.top == rightLabel.top
            topLabel.left == avatar.right + 10
            topLabel.right == rightLabel.left
        }
        
        layout(headerLabel, footerLabel) { topLabel, bottomLabel in
            
            bottomLabel.top == topLabel.bottom
            bottomLabel.left == topLabel.left
            bottomLabel.right == topLabel.right
            
            bottomLabel.height == topLabel.height
        }
    }
}
