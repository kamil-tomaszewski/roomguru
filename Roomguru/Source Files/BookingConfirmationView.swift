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

    var minutesToBookLabel: UILabel = UILabel()
    
    var confirmButton: UIButton = UIButton()
    var cancelButton: UIButton = UIButton()
    
    var lessMinutesButton: UIButton = UIButton()
    var moreMinutesButton: UIButton = UIButton()
    
    var summaryTextField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private var minutesShortLabel: UILabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
    
    private func commonInit() {
        self.backgroundColor = UIColor.whiteColor()
        
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
    
    private func defineConstraints() {
        
        layout(confirmButton, cancelButton) { (confirm, cancel) in
            confirm.left == confirm.superview!.left + 20
            confirm.bottom == confirm.superview!.bottom - 20
            
            cancel.right == confirm.superview!.right - 20
            cancel.bottom == confirm.superview!.bottom - 20
            
            confirm.right == cancel.left - 20
            
            confirm.height == 50
            confirm.width == cancel.width
            cancel.height == confirm.height
        }
        
        layout(minutesToBookLabel, minutesShortLabel) { (book, short) in
            book.center == book.superview!.center
            book.width == 70
            book.height == 50
            
            short.width == book.width
            short.centerX == book.centerX
            short.top == book.bottom
        }
        
        layout(lessMinutesButton, minutesToBookLabel) { (button, book) in
            button.width == 44
            button.height == 44
            button.centerY == button.superview!.centerY
            button.right == book.left
        }
        
        layout(moreMinutesButton, minutesToBookLabel) { (button, book) in
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
    
    private func configureButtonsAppearance() {        
        setupButton(&self.lessMinutesButton, withTitle: NSLocalizedString("<", comment: ""))
        setupButton(&self.moreMinutesButton, withTitle: NSLocalizedString(">", comment: ""))
        
        setupRoundButton(&self.confirmButton, withTitle: NSLocalizedString("Book", comment: ""), color: UIColor.ngOrangeColor())
        setupRoundButton(&self.cancelButton, withTitle: NSLocalizedString("Cancel", comment: ""), color: UIColor.ngOrangeColor())
    }
    
    private func setupButton(inout button: UIButton, withTitle title: String) {
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
    
    private func configureLabelsAppearance() {
        self.minutesShortLabel.text = NSLocalizedString("minutes", comment: "")
        self.minutesShortLabel.numberOfLines = 1
        self.minutesShortLabel.adjustsFontSizeToFitWidth = true
        self.minutesShortLabel.textAlignment = .Center
        
        self.minutesToBookLabel.font = UIFont.boldSystemFontOfSize(28.0)
        self.minutesToBookLabel.textAlignment = .Center
    }
    
    private func configureTextFieldAppearance() {
        self.summaryTextField.placeholder = NSLocalizedString("Summary", comment: "")
        self.summaryTextField.borderStyle = .RoundedRect
    }
}
