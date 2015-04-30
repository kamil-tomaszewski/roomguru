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

protocol FreeEventCellDelegate: class {
    func eventCell(cell: FreeEventCell, didChoseTimePeriod timePeriod: NSTimeInterval)
}


class FreeEventCell: BaseEventCell, Reusable {
    
    weak var delegate: FreeEventCellDelegate?
    
//    let freeTimeButton: UIButton = UIButton()
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
    
    private struct Constants { static var CellIdentifier: String = "TableViewFreeEventCellReuseIdentifier"}
    
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
    

    
    override func defineConstraints() {
        
        layout(bookingTimesView) { bookingView in
//            freeButton.edges == freeButton.superview!.edges
            bookingView.edges == bookingView.superview!.edges
            return
        }
        
        layout(timeMaxLabel, timeMinLabel) { upperLabel, lowerLabel in
            upperLabel.top >= upperLabel.superview!.top + 5
            upperLabel.left == upperLabel.superview!.left + 10
            
            lowerLabel.bottom >= lowerLabel.superview!.bottom - 5
            lowerLabel.left == lowerLabel.superview!.left + 10
            lowerLabel.width == upperLabel.width
            lowerLabel.height == upperLabel.height
        }
    }
}

private extension FreeEventCell {
    
    func commonInit() {
        
        indentationLevel = 7
        contentView.backgroundColor = UIColor.rgb(255, 167, 34)
        
        bookingTimesView.delegate = self
        contentView.addSubview(bookingTimesView)
        
        timeMaxLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMaxLabel)
        
        timeMinLabel.font = .boldSystemFontOfSize(13.0)
        contentView.addSubview(timeMinLabel)
        
        //        contentView.addSubview(freeTimeButton)
        //        freeTimeButton.setTitleColor(white, forState: .Normal)
        //        freeTimeButton.setTitleColor(lightGray, forState: .Highlighted)
        //        freeTimeButton.backgroundColor = UIColor.clearColor()
        //        freeTimeButton.addTarget(self, action: Selector("didTapFreeTimeButton:"))
        //        freeTimeButton.backgroundColor = backgroundColor

        defineConstraints()
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
        
//        stateBlock = Async.main(after: 5.0) {
//            self.toggleState()
//        }
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
//        freeTimeButton.addTarget(self, action: Selector("didTapFreeTimeButton:"))
        
        let actions: () -> Void = {
//            self.freeTimeButton.alpha = 1.0
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
//        freeTimeButton.removeTarget(self, action: Selector("didTapFreeTimeButton:"))
        
        let actions: () -> Void = {
            self.backgroundColor = UIColor.greenColor()
//            self.freeTimeButton.alpha = 0.0
        }
        
        if animated {
            UIView.animateWithDuration(0.25, animations: actions)
        } else {
            actions()
        }
    }
}
