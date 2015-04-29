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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let weekCarouselView = weekCarouselView, eventsPageView = eventsPageView {
            
            weekCarouselView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 90)
            eventsPageView.frame = CGRectMake(0, CGRectGetMaxY(weekCarouselView.frame), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(weekCarouselView.frame))
        }
    }
}
