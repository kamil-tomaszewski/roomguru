//
//  EventsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsView: UIView {
    
    weak var roomPickerView: UIView?
    weak var eventsPageView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let roomPickerView = roomPickerView, eventsPageView = eventsPageView {
            
            let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
            
            roomPickerView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 60)
            eventsPageView.frame = CGRectMake(0, CGRectGetMaxY(roomPickerView.frame), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(roomPickerView.frame))
        }
    }
}

private extension EventsView {
    
    func commonInit() {
        backgroundColor = .ngGrayColor()
    }
}
