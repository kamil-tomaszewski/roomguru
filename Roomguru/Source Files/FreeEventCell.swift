//
//  FreeEventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography


protocol FreeEventCellDelegate: class {
    func didTapEventCell(cell: FreeEventCell)
}


class FreeEventCell: UITableViewCell {
    
    weak var delegate: FreeEventCellDelegate?
    let freeTimeButton: UIButton = UIButton()
    
    private struct aStruct { static var staticVar: String = "TableViewFreeEventCellReuseIdentifier"}
    
    class var reuseIdentifier: String {
        get { return aStruct.staticVar }
        set { aStruct.staticVar = newValue }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func didTapFreeTimeButton(sender: UIButton) {
        if let _delegate = delegate {
            _delegate.didTapEventCell(self)
        }
    }
    
    // MARK: Private
    
    private func commonInit() {
        configure()
        contentView.addSubview(freeTimeButton)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(freeTimeButton) { freeButton in
            freeButton.edges == freeButton.superview!.edges
            return
        }
    }
    
    private func configure() {
        let white = UIColor.whiteColor()
        
        freeTimeButton.setTitleColor(white, forState: .Normal)
        freeTimeButton.backgroundColor = UIColor.clearColor()
        freeTimeButton.addTarget(self, action: Selector("didTapFreeTimeButton:"))
        
        contentView.backgroundColor = UIColor(red: 1.0, green: 167/255.0, blue: 34/255.0, alpha: 1.0)
    }
}
