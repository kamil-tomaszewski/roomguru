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
    private(set) var placeholderView: EmptyCalendarPlaceholderView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let weekCarouselView = weekCarouselView, eventsPageView = eventsPageView {
            weekCarouselView.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), 90)
            eventsPageView.frame = CGRectMake(0, CGRectGetMaxY(weekCarouselView.frame), CGRectGetWidth(bounds), CGRectGetHeight(bounds) - CGRectGetMaxY(weekCarouselView.frame))
        }
        placeholderView?.frame = bounds
    }
    
    func showPlaceholderView(show: Bool) {
        
        if show {
            placeholderView = EmptyCalendarPlaceholderView(frame: frame)
            addSubview(placeholderView!)
        
            setNeedsLayout()
        } else {
            placeholderView?.removeFromSuperview()
            placeholderView = nil
        }
        
        weekCarouselView?.hidden = show
        eventsPageView?.hidden = show
    }
}
