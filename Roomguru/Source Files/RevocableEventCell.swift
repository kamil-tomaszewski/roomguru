//
//  RevocableEventCell.swift
//  Roomguru
//
//  Created by Aleksander Popko on 24.04.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RevocableEventCell: BaseEventCell, Reusable {
    
    let revokeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var revokeButtonHandler : VoidBlock?
    
    class func reuseIdentifier() -> String {
        return "TableViewEventCellReuseIdentifier"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        layout(revokeButton) { aButton in
            aButton.centerY == aButton.superview!.centerY
            aButton.right == aButton.superview!.right - 10
            aButton.width == 65
            aButton.height == 35
        }
    }
    
    func didTapRevokeButton(sender:UIButton) {
        if let handler:VoidBlock = revokeButtonHandler{
            handler()
        }
    }
}

private extension RevocableEventCell {

    func commonInit() {
        configure()
        self.addSubview(revokeButton)
        contentView.addSubview(timeMaxLabel)
        contentView.addSubview(timeMinLabel)
        defineConstraints()
    }
    
    func configure() {
        revokeButton.setTitle("Revoke")
        revokeButton.setTitleColor(UIColor.ngOrangeColor(), forState: UIControlState.Normal)
        revokeButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        revokeButton.addTarget(self, action: Selector("didTapRevokeButton:"))
        let font = UIFont.boldSystemFontOfSize(13.0)
        timeMaxLabel.font = font
        timeMinLabel.font = font
        indentationLevel = 7
    }
}
