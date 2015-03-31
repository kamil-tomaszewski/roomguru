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
    let avatarImageView = UIImageView()
    
    private struct aStruct { static var staticVar: String = "TableViewAttendeeCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return aStruct.staticVar }
        set { aStruct.staticVar = newValue }
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
        avatarImageView.image = nil
    }
    
    // MARK: Public
    
    func setMarkWithStatus(status: Status?) {
        
        var mark = ""
        if let _status = status {
            
            switch _status {
            case .Awaiting:
                mark =  String.fontAwesomeIconWithName(.ClockO)
            case .NotGoing:
                mark =  String.fontAwesomeIconWithName(.Ban)
            case .Maybe:
                mark =  String.fontAwesomeIconWithName(.Question)
            case .Going:
                mark =  String.fontAwesomeIconWithName(.Check)
            }
        }
        statusLabel.text = mark
    }
    
    // MARK: Private
    
    private func commonInit() {
        
        headerLabel.font = UIFont.systemFontOfSize(16)
        contentView.addSubview(headerLabel)
        
        footerLabel.textColor = UIColor.darkGrayColor()
        footerLabel.font = UIFont.systemFontOfSize(14)
        contentView.addSubview(footerLabel)
        
        statusLabel.font = UIFont.fontAwesomeOfSize(20)
        statusLabel.textColor = UIColor.ngOrangeColor()
        statusLabel.textAlignment = .Center
        contentView.addSubview(statusLabel)
        
        avatarImageView.contentMode = .ScaleAspectFit
        contentView.addSubview(avatarImageView)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(avatarImageView, statusLabel, headerLabel) { imageView, rightLabel, topLabel in
            
            let margins: (H: CGFloat, V: CGFloat) = (15, 10)
            
            imageView.top == imageView.superview!.top + margins.V
            imageView.bottom == imageView.superview!.bottom - margins.V
            imageView.left == rightLabel.superview!.left + margins.H
            imageView.width == imageView.superview!.height - 2 * margins.V
            
            rightLabel.top == rightLabel.superview!.top + margins.V
            rightLabel.bottom == rightLabel.superview!.bottom - margins.V
            rightLabel.right == rightLabel.superview!.right - margins.H
            rightLabel.width == 30
            
            topLabel.top == rightLabel.top
            topLabel.left == imageView.right + 10
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
