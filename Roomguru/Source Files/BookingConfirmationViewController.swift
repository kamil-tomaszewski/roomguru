//
//  BookingConfirmationViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 30/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class BookingConfirmationViewController: UIViewController {
    
    private let viewModel: BookingConfirmationViewModel
    private weak var aView: BookingConfirmationView?
    private var didConfirmBlock: ((bookedEntry: CalendarEntry) -> Void)?
    
    var editable = true
    
    init(bookableEntry: CalendarEntry, didConfirmBlock: ((bookedEntry: CalendarEntry) -> Void)? = nil) {
        self.didConfirmBlock = didConfirmBlock
        self.viewModel = BookingConfirmationViewModel(entry: bookableEntry)
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: Lifecycle
    
    override func loadView() {
        aView = loadViewWithClass(BookingConfirmationView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.titleView = basicTitleView()
        
        if !editable {
            aView?.lessMinutesButton.hidden = true
            aView?.moreMinutesButton.hidden = true
        }
        
        aView?.moreMinutesButton.enabled = viewModel.canAddMinutes
        aView?.summaryTextField.delegate = self
        aView?.summaryTextField.addTarget(self, action: "textFieldDidChangeText:", forControlEvents: UIControlEvents.EditingChanged)
        
        updateViewForValidationResult(viewModel.isValid())
        updateActualBookingTimeLabel()
        connectActions()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        aView?.summaryTextField.becomeFirstResponder()
    }
    
    private func basicTitleView() -> BasicTitleView {
        let basicTitleView = BasicTitleView(frame: navigationController!.navigationBar.frame)
        basicTitleView.textLabel.text = viewModel.title
        basicTitleView.detailTextLabel.text = viewModel.detailTitle
        return basicTitleView
    }
}

// MARK: Actions

extension BookingConfirmationViewController {
    
    func didTapConfirmButton(sender: UIButton) {
        view.findFirstResponder()?.resignFirstResponder()
        
        dismissViewControllerAnimated(true) { [weak self] in
            if let this = self {
                this.didConfirmBlock?(bookedEntry: this.viewModel.entry)
            }
        }
    }
    
    func didTapCancelButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapLessMinutesButton(sender: UIButton) {
        viewModel.decreaseBookingTime()
        updateActualBookingTimeLabel()
        
        sender.enabled = viewModel.canSubstractMinutes
        aView?.moreMinutesButton.enabled = viewModel.canAddMinutes
    }
    
    func didTapMoreMinutesButton(sender: UIButton) {
        viewModel.increaseBookingTime()
        updateActualBookingTimeLabel()
        
        sender.enabled = viewModel.canAddMinutes
        aView?.lessMinutesButton.enabled = viewModel.canSubstractMinutes
    }
}


// MARK: UITextFieldDelegate

extension BookingConfirmationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        viewModel.entry.event.setCustomSummary(textField.text)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension BookingConfirmationViewController {
    
    func textFieldDidChangeText(textField: UITextField) {
        updateViewForValidationResult(viewModel.validate(textField.text))
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

    func updateActualBookingTimeLabel() {
        if editable {
            aView?.minutesToBookLabel.text = viewModel.bookingDurationInMinutes
        } else {
            aView?.minutesToBookLabel.text = "\(Int(viewModel.entry.event.duration/60))"
        }
    }
}
