//
//  EventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class EventCell: BaseEventCell, Reusable {
    
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
}

private extension EventCell {
    
    func commonInit() {
        
        indentationLevel = 7
        timeMaxLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMaxLabel)
        
        timeMinLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMinLabel)
        
        defineConstraints()
    }
}
