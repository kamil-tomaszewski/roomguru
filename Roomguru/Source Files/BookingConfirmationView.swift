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

    let minutesToBookLabel: UILabel = UILabel()
    
    private(set) var confirmButton: UIButton = UIButton()
    private(set) var cancelButton: UIButton = UIButton()
    
    private(set) var lessMinutesButton: UIButton = UIButton()
    private(set) var moreMinutesButton: UIButton = UIButton()
    
    let summaryTextField: UITextField = UITextField()
    
    private let minutesShortLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

private extension BookingConfirmationView {
    
    func commonInit() {
        backgroundColor = .whiteColor()
        
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
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
    }
    
    private func setupRoundButton(inout button: UIButton, withTitle title: String, color: UIColor) {
        button.setTitle(title, forState: .Normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 5.0
    }
    
    func configureLabelsAppearance() {
        self.minutesShortLabel.text = NSLocalizedString("minutes", comment: "")
        self.minutesShortLabel.numberOfLines = 1
        self.minutesShortLabel.adjustsFontSizeToFitWidth = true
        self.minutesShortLabel.textAlignment = .Center
        
        self.minutesToBookLabel.font = UIFont.boldSystemFontOfSize(28.0)
        self.minutesToBookLabel.textAlignment = .Center
    }
    
    func configureTextFieldAppearance() {
        self.summaryTextField.placeholder = NSLocalizedString("Summary", comment: "")
        self.summaryTextField.borderStyle = .RoundedRect
    }
}
