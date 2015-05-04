//
//  BookingConfirmationViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: UIViewController {
    
    private weak var aView: BookingConfirmationView?
    
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

        if let startDate = calendarTime.0?.startDate, endDate = calendarTime.0?.endDate {
            let startDateString = timeFormatter.stringFromDate(startDate)
            let endDateString = timeFormatter.stringFromDate(endDate)
            navigationItem.title = "Room " + calendarTime.1.roomName() + " | " + startDateString + " - " + endDateString
        }
        
        if actualBookingTime.0?.duration() >= calendarTime.0?.duration() {
            aView?.moreMinutesButton.enabled = false
        }
        
        aView?.summaryTextField.delegate = self
        isValid = false
        
        updateActualBookingTimeLabel()
        connectActions()
    }
    
    // MARK: Private 
    
    private var actualBookingTime: CalendarTimeFrame = (nil, "")
    private var calendarTime: CalendarTimeFrame = (nil, "")
    private var summary = NSLocalizedString("Summary", comment: "") {
        didSet { isValid = summary.length >= 5 }
    }
    private var confirmation: (CalendarTimeFrame, String) -> Void = { (calendarTime, summary) in }
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var timeFormatter: NSDateFormatter = NSDateFormatter()
    private var isValid = false {
        didSet { updateViewForValidationResult(isValid) }
    }
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
        
        sender.enabled = actualBookingTime.0?.duration() > 900
        aView?.moreMinutesButton.enabled = true
    }
    
    func didTapMoreMinutesButton(sender: UIButton) {
        addMinutesToActualBookingTime(15)
        updateActualBookingTimeLabel()
        
        sender.enabled = actualBookingTime.0?.duration() < calendarTime.0?.duration()
        
        aView?.lessMinutesButton.enabled = true
    }
}


// MARK: UITextFieldDelegate

extension BookingConfirmationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        summary = textField.text
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private

private extension BookingConfirmationViewController {
    
    func updateViewForValidationResult(result: Bool) {
        if result {
            aView?.removeErrorFromSummaryTextField()
            aView?.confirmButton.backgroundColor = .ngOrangeColor()
        } else {
            aView?.markErrorOnSummaryTextField()
            aView?.confirmButton.backgroundColor = .lightGrayColor()
        }
        
        aView?.confirmButton.enabled = result
    }
    
    func connectActions() {
        aView?.confirmButton.enabled = false
        aView?.confirmButton.addTarget(self, action: Selector("didTapConfirmButton:"))
        aView?.cancelButton.addTarget(self, action: Selector("didTapCancelButton:"))
        aView?.lessMinutesButton.addTarget(self, action: Selector("didTapLessMinutesButton:"))
        aView?.moreMinutesButton.addTarget(self, action: Selector("didTapMoreMinutesButton:"))
    }

    func addMinutesToActualBookingTime(minutes: Int) {
        let actualTimeFrame = self.actualBookingTime.0
        
        if let _actualTimeFrame = actualTimeFrame {
            let endDate = _actualTimeFrame.endDate.minutes.add(minutes).date
            let timeFrame = TimeFrame(startDate: _actualTimeFrame.startDate, endDate: endDate, availability: _actualTimeFrame.availability)
            self.actualBookingTime = (timeFrame, self.actualBookingTime.1)
        }
    }

    func updateActualBookingTimeLabel() {
        if let duration = self.actualBookingTime.0?.duration() {
            aView?.minutesToBookLabel.text = "\(Int(duration/60))"
        }
    }
    
}

