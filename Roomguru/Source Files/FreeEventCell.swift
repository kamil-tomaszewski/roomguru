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
    case Normal, Tapped
}

protocol FreeEventCellDelegate {
    func eventCell(cell: FreeEventCell, didChoseTimePeriod timePeriod: NSTimeInterval)
}

class FreeEventCell: EventCell {
    
    private let bookingTimesView: BookingTimesView = BookingTimesView(frame: CGRectZero)
    
    var delegate: FreeEventCellDelegate?
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
    
    override class func reuseIdentifier() -> String {
        return "TableViewFreeEventCellReuseIdentifier"
    }

    override func commonInit() {
    
        contentView.backgroundColor = UIColor.ngOrangeColor()
        
        bookingTimesView.delegate = self
        contentView.addSubview(bookingTimesView)

        super.commonInit()
    }
    
    override func defineConstraints() {
        super.defineConstraints()
        
        layout(bookingTimesView) { bookingView in
            bookingView.edges == bookingView.superview!.edges; return
        }
    }
}

// MARK: BookingTimesViewDelegate

extension FreeEventCell: BookingTimesViewDelegate {
    
    func didChooseTimePeriod(timePeriod: NSTimeInterval) {
        
        invalidate()
        delegate?.eventCell(self, didChoseTimePeriod: timePeriod)
    }
}

// MARK: Actions

extension FreeEventCell {
 
    func didTapFreeTimeButton(sender: UIButton) {
        toggleState()
    }
}

// MARK: Cell State Handling

extension FreeEventCell {
    
    func invalidate() {
        setNormalState()
        stateBlock?.cancel()
    }
    
    func toggleState(animated: Bool = true) {
        if cellState == .Normal {
            setTappedState(animated: animated)
        } else {
            setNormalState(animated: animated)
        }
    }
    
    private func setNormalState(animated: Bool = false) {
        cellState = .Normal
        
        let actions: VoidBlock = {
            self.backgroundColor = UIColor.clearColor()
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: actions)
        } else {
            actions()
        }
    }
    
    private func setTappedState(animated: Bool = false) {
        cellState = .Tapped
        
        let actions: VoidBlock = {
            self.backgroundColor = UIColor.greenColor()
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: actions)
        } else {
            actions()
        }
    }
}
