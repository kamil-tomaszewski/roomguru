//
//  RevocableEventCell.swift
//  Roomguru
//
//  Created by Aleksander Popko on 24.04.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class RevocableEventCell: EventCell {
    
    let revokeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
    var revokeButtonHandler : (()->())?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupRevokeButton()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRevokeButton()
    }
    
    func onRevokeButtonClicked(sender:UIButton) {
        if let handler:(()->()) = revokeButtonHandler{
            handler()
        }
    }
    
    private func setupRevokeButton(){
        revokeButton.setTitle("Revoke")
        revokeButton.setTitleColor(UIColor.ngOrangeColor(), forState: UIControlState.Normal)
        revokeButton.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
        revokeButton.addTarget(self, action: Selector("onRevokeButtonClicked:"))
        self.addSubview(revokeButton)
        defineRevokeButtonConstraints()
    }
    
    private func defineRevokeButtonConstraints() {
        layout(revokeButton) { aButton in
            aButton.centerY == aButton.superview!.centerY
            aButton.right == aButton.superview!.right - 10
            aButton.width == 65
            aButton.height == 35
        }
    }
}
