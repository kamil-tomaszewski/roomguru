//
//  EventDetailsViewModel.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

typealias AttendeeInfo = (name: String?, email: String?, status: Status?)

class EventDetailsViewModel: NSObject {
    
    private let event: Event?
    private let formatter: NSDateFormatter
    
    init(event: Event?) {
        self.event = event
        self.formatter = NSDateFormatter()
        self.formatter.dateFormat = "MMMM, dd eee YYYY"
        super.init()
    }
    
    // MARK: numbers
    
    func numberOfGuests() -> Int {
        return event?.attendees?.count ?? 0
    }
    
    func numberOfLocations() -> Int {
        return event?.rooms?.count ?? 0
    }
    
    // MARK: text
    
    func hangoutURL() -> NSURL? {
        if let string = event?.hangoutLink {
            return NSURL(string: string)
        }
        return nil
    }
    
    func attendee(index: Int) -> AttendeeInfo {
        return infoWithAttendee(event?.attendees?[index])
    }
    
    func owner() -> AttendeeInfo {
        return infoWithAttendee(event?.organizer)
    }
    
    func location(index: Int) -> AttendeeInfo {
        return infoWithAttendee(event?.rooms?[index])
    }
    
    func summary() -> NSAttributedString {
        
        var attributedString = NSMutableAttributedString()
        
        func append(string: String, font: UIFont) {
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineBreakMode = .ByWordWrapping
            paragraph.lineSpacing = 8
            
            let attributes = [
                NSFontAttributeName : font,
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: paragraph
            ]
            attributedString.appendAttributedString(NSAttributedString(string: string, attributes: attributes))
        }
        
        if let summary = event?.summary {
            append(summary + "\n", UIFont.boldSystemFontOfSize(16.0))
        }
        
        if let date = event?.start {
            append(formatter.stringFromDate(date) + "\n", UIFont.systemFontOfSize(14.0))
        }
        
        if let startTime = event?.startTime {
            if let endTime = event?.endTime {
                let string = NSLocalizedString("from", comment: "") + " " + startTime + " " + NSLocalizedString("to", comment: "") + " " + endTime
                append(string, UIFont.systemFontOfSize(14.0))
            }
        }
        
        return attributedString.copy() as NSAttributedString
    }
}

// MARK: Private

private extension EventDetailsViewModel {
    
    private func infoWithAttendee(attendee: Attendee?) -> AttendeeInfo  {
        if let _attendee = attendee {
            return (_attendee.name, _attendee.email, _attendee.status)
        }
        return (nil, nil, nil)
    }
}
