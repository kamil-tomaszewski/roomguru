//
//  EventsView.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 29/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class EventsView: UIView {
    
    weak var weekCarouselView: UIView?
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
        
        if let weekCarouselView = weekCarouselView, eventsPageView = eventsPageView {
            
            weekCarouselView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 60)
            eventsPageView.frame = CGRectMake(0, CGRectGetMaxY(weekCarouselView.frame), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(weekCarouselView.frame))
        }
    }
}

private extension EventsView {
    
    func commonInit() {
        backgroundColor = .ngGrayColor()
    }
}
