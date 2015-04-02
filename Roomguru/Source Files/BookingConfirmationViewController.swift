//
//  BookingConfirmationViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit


class BookingConfirmationViewController: UIViewController {
    
    weak var aView: BookingConfirmationView?
    
    init(_ calendarTime: CalendarTimeFrame, onConfirmation confirmation: (CalendarTimeFrame, String) -> Void) {
        self.calendarTime = calendarTime
        self.confirmation = confirmation
        
        self.dateFormatter.timeZone = NSTimeZone.localTimeZone()
        self.timeFormatter.timeZone = NSTimeZone.localTimeZone()
        self.dateFormatter.dateStyle = .ShortStyle
        self.timeFormatter.timeStyle = .ShortStyle
        
        let today = NSDate()
        let endDate = today.minutes.add(30).date
        let timeFrame = TimeFrame(startDate: today, endDate: endDate, availability: .Available)
        self.actualBookingTime = (timeFrame, self.calendarTime.1)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(BookingConfirmationView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let startDate = calendarTime.0?.startDate {
            if let endDate = calendarTime.0?.endDate {
                let startDateString = timeFormatter.stringFromDate(startDate)
                let endDateString = timeFormatter.stringFromDate(endDate)
                self.navigationItem.title = "Room " + calendarTime.1.roomName() + " | " + startDateString + " - " + endDateString
            }
        }
        
        aView?.summaryTextField.delegate = self
        
        updateActualBookingTimeLabel()
        connectActions()
    }
    
    // MARK: Private 
    
    private var actualBookingTime: CalendarTimeFrame = (nil, "")
    private var calendarTime: CalendarTimeFrame = (nil, "")
    private var summary: String = NSLocalizedString("Summary", comment: "")
    private var confirmation: (CalendarTimeFrame, String) -> Void = { (calendarTime, summary) in }
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var timeFormatter: NSDateFormatter = NSDateFormatter()
    
}


// MARK: Actions

extension BookingConfirmationViewController {
    
    func didTapConfirmButton(sender: UIButton) {
        dismissViewControllerAnimated(true) {
            self.confirmation(self.actualBookingTime, self.summary)
        }
    }
    
    func didTapCancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapLessMinutesButton(sender: UIButton) {
        addMinutesToActualBookingTime(-15)
        updateActualBookingTimeLabel()
        
        sender.enabled = self.actualBookingTime.0?.duration() > 900
        aView?.moreMinutesButton.enabled = true
    }
    
    func didTapMoreMinutesButton(sender: UIButton) {
        addMinutesToActualBookingTime(15)
        updateActualBookingTimeLabel()
        
        sender.enabled = self.actualBookingTime.0?.duration() < self.calendarTime.0?.duration()
        
        aView?.lessMinutesButton.enabled = true
    }
    
}


// MARK: UITextFieldDelegate

extension BookingConfirmationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.summary = textField.text
    }
    
}


// MARK: Private

extension BookingConfirmationViewController {
    
    private func connectActions() {
        aView?.confirmButton.addTarget(self, action: Selector("didTapConfirmButton:"))
        aView?.cancelButton.addTarget(self, action: Selector("didTapCancelButton:"))
        aView?.lessMinutesButton.addTarget(self, action: Selector("didTapLessMinutesButton:"))
        aView?.moreMinutesButton.addTarget(self, action: Selector("didTapMoreMinutesButton:"))
    }

    private func addMinutesToActualBookingTime(minutes: Int) {
        let actualTimeFrame = self.actualBookingTime.0
        
        if let _actualTimeFrame = actualTimeFrame? {
            let endDate = _actualTimeFrame.endDate.minutes.add(minutes).date
            let timeFrame = TimeFrame(startDate: _actualTimeFrame.startDate, endDate: endDate, availability: _actualTimeFrame.availability)
            self.actualBookingTime = (timeFrame, self.actualBookingTime.1)
        }
    }

    private func updateActualBookingTimeLabel() {
        if let duration = self.actualBookingTime.0?.duration() {
            aView?.minutesToBookLabel.text = "\(Int(duration/60))"
        }
    }
    
}

