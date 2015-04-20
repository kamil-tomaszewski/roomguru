//
//  SettingsCell.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 16/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class SettingsCell: UICollectionViewCell, Reusable {
    
    class func reuseIdentifier() -> String {
        return "UICollectionViewSettingsCellReuseIdentifier"
    }

    let textLabel = UILabel()
    private let line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        backgroundColor = UIColor.whiteColor()
        
        line.backgroundColor = UIColor.rgb(200, 200, 200)
        addSubview(line)
        
        addSubview(textLabel)
        
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(textLabel, line) { label, line in
            
            label.edges == inset(label.superview!.edges, 10, 10)
            
            line.height == 1
            line.width == line.superview!.width
            line.left == line.superview!.left
            line.bottom == line.superview!.bottom
        }
    }
}
