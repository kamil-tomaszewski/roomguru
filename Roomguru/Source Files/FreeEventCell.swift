//
//  FreeEventCell.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 24/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography
import Async


enum FreeEventCellState {
    case Normal
    case Tapped
}


protocol FreeEventCellDelegate: class {
    func eventCell(cell: FreeEventCell, didChoseTimePeriod timePeriod: NSTimeInterval)
}


class FreeEventCell: UITableViewCell, Reusable {
    
    weak var delegate: FreeEventCellDelegate?
    
    let freeTimeButton: UIButton = UIButton()
    let bookingTimesView: BookingTimesView = BookingTimesView(frame: CGRectZero)

    var timePeriod: NSTimeInterval {
        get { return _timePeriod }
        set {
            _timePeriod = newValue
            bookingTimesView.configureForTimePeriod(newValue)
        }
    }
    
    private var _timePeriod: NSTimeInterval = 0
    private var cellState: FreeEventCellState = .Normal
    private var stateBlock: Async?
    
    class func reuseIdentifier() -> String {
        return "TableViewFreeEventCellReuseIdentifier"
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Private
    
    private func commonInit() {
        configure()
        contentView.addSubview(bookingTimesView)
        contentView.addSubview(freeTimeButton)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(freeTimeButton, bookingTimesView) { freeButton, bookingView in
            freeButton.edges == freeButton.superview!.edges
            bookingView.edges == bookingView.superview!.edges
            return
        }
    }
    
    private func configure() {
        let white = UIColor.whiteColor()
        let lightGray = UIColor.lightGrayColor()
        let backgroundColor = UIColor(red: 1.0, green: 167/255.0, blue: 34/255.0, alpha: 1.0)
        
        freeTimeButton.setTitleColor(white, forState: .Normal)
        freeTimeButton.setTitleColor(lightGray, forState: .Highlighted)
        freeTimeButton.backgroundColor = UIColor.clearColor()
        freeTimeButton.addTarget(self, action: Selector("didTapFreeTimeButton:"))
        freeTimeButton.backgroundColor = backgroundColor
        
        bookingTimesView.delegate = self
        
        contentView.backgroundColor = backgroundColor
    }
    
}

// MARK: BookingTimesViewDelegate

extension FreeEventCell: BookingTimesViewDelegate {
    
    func didChooseTimePeriod(timePeriod: NSTimeInterval) {
        
        invalidate()
        
        if let _delegate = delegate {
            _delegate.eventCell(self, didChoseTimePeriod: timePeriod)
        }
        
    }
    
}

// MARK: Actions

extension FreeEventCell {
 
    func didTapFreeTimeButton(sender: UIButton) {
        toggleState()
        
        stateBlock = Async.main(after: 5.0) {
            self.toggleState()
        }
    }
    
}

// MARK: Cell State Handling

extension FreeEventCell {
    
    func invalidate() {
        setNormalState()
        stateBlock?.cancel()
    }
    
    private func toggleState(animated: Bool = true) {
        if cellState == .Normal {
            setTappedState(animated: animated)
        } else {
            setNormalState(animated: animated)
        }
    }
    
    private func setNormalState(animated: Bool = false) {
        cellState = .Normal
        freeTimeButton.addTarget(self, action: Selector("didTapFreeTimeButton:"))
        
        let actions: () -> Void = {
            self.freeTimeButton.alpha = 1.0
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: actions)
        } else {
            actions()
        }
    }
    
    private func setTappedState(animated: Bool = false) {
        cellState = .Tapped
        freeTimeButton.removeTarget(self, action: Selector("didTapFreeTimeButton:"))
        
        let actions: () -> Void = {
            self.freeTimeButton.alpha = 0.0
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: actions)
        } else {
            actions()
        }
    }
    
}
