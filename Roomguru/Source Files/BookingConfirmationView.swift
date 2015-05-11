//
//  BookingConfirmationView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

class BookingConfirmationView: UIView {

    let minutesToBookLabel = UILabel()
    
    private(set) var confirmButton = UIButton.buttonWithType(.System) as! UIButton
    private(set) var cancelButton = UIButton.buttonWithType(.System) as! UIButton
    
    private(set) var lessMinutesButton = UIButton.buttonWithType(.System) as! UIButton
    private(set) var moreMinutesButton = UIButton.buttonWithType(.System) as! UIButton
    
    let summaryTextField = TextField()
    
    private let minutesShortLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension BookingConfirmationView {
    
    func markErrorOnSummaryTextField() {
        updateAccessoryLabelWithFontAwesome(.ExclamationCircle, color: .ngRedColor())
    }
    
    func removeErrorFromSummaryTextField() {
        updateAccessoryLabelWithFontAwesome(.CheckCircle, color: .ngGreenColor())
    }
    
    private func updateAccessoryLabelWithFontAwesome(fontAwesome: FontAwesome, color: UIColor) {
        if let label = summaryTextField.leftView as? UILabel {
            label.text = .fontAwesomeIconWithName(fontAwesome)
            label.textColor = color
        }
    }
}

private extension BookingConfirmationView {
    
    func commonInit() {
        backgroundColor = .whiteColor()
        
        summaryTextField.leftView = UILabel.roundedExclamationMarkLabel(CGRectMake(0, 0, 30, 30))
        summaryTextField.leftViewMode = .Always
        markErrorOnSummaryTextField()
        
        configureButtonsAppearance()
        configureLabelsAppearance()
        configureTextFieldAppearance()
        
        addSubview(confirmButton)
        addSubview(cancelButton)
        addSubview(lessMinutesButton)
        addSubview(moreMinutesButton)
        
        addSubview(minutesToBookLabel)
        addSubview(minutesShortLabel)
        
        addSubview(summaryTextField)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(confirmButton, cancelButton) { confirm, cancel in
            confirm.left == confirm.superview!.left + 20
            confirm.bottom == confirm.superview!.bottom - 20
            
            cancel.right == confirm.superview!.right - 20
            cancel.bottom == confirm.superview!.bottom - 20
            
            confirm.right == cancel.left - 20
            
            confirm.height == 50
            confirm.width == cancel.width
            cancel.height == confirm.height
        }
        
        layout(minutesToBookLabel, minutesShortLabel) { book, short in
            book.center == book.superview!.center
            book.width == 70
            book.height == 50
            
            short.width == book.width
            short.centerX == book.centerX
            short.top == book.bottom
        }
        
        layout(lessMinutesButton, minutesToBookLabel) { button, book in
            button.width == 44
            button.height == 44
            button.centerY == button.superview!.centerY
            button.right == book.left
        }
        
        layout(moreMinutesButton, minutesToBookLabel) { button, book in
            button.width == 44
            button.height == 44
            button.centerY == button.superview!.centerY
            button.left == book.right
        }
        
        layout(summaryTextField) { textField in
            textField.top == textField.superview!.top + 84
            textField.left == textField.superview!.left + 20
            textField.right == textField.superview!.right - 20
            textField.height == 30
            return
        }
    }
    
    func configureButtonsAppearance() {
        setupButton(&lessMinutesButton, withTitle: NSLocalizedString("<", comment: ""))
        setupButton(&moreMinutesButton, withTitle: NSLocalizedString(">", comment: ""))
        
        setupRoundButton(&confirmButton, withTitle: NSLocalizedString("Book", comment: ""), color: .ngOrangeColor())
        setupRoundButton(&cancelButton, withTitle: NSLocalizedString("Cancel", comment: ""), color: .ngOrangeColor())
    }
    
    func setupButton(inout button: UIButton, withTitle title: String) {
        button.setTitle(title)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)

    }
    
    func setupRoundButton(inout button: UIButton, withTitle title: String, color: UIColor) {
        button.setTitle(title)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5.0
    }
    
    func configureLabelsAppearance() {
        minutesShortLabel.text = NSLocalizedString("minutes", comment: "")
        minutesShortLabel.numberOfLines = 1
        minutesShortLabel.adjustsFontSizeToFitWidth = true
        minutesShortLabel.textAlignment = .Center
        
        minutesToBookLabel.font = UIFont.boldSystemFontOfSize(28.0)
        minutesToBookLabel.textAlignment = .Center
    }
    
    func configureTextFieldAppearance() {
        summaryTextField.placeholder = NSLocalizedString("Summary (min. 5 characters)", comment: "")
        summaryTextField.borderStyle = .RoundedRect
        summaryTextField.leftInset = 30
    }
}
