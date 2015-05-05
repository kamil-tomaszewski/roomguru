//
//  BookingTimesView.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 25/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import Cartography

protocol BookingTimesViewDelegate: class {
    func didChooseTimePeriod(timePeriod: NSTimeInterval)
}

class BookingTimesView: UIView {
    
    weak var delegate: BookingTimesViewDelegate?
    
    let timeButton = UIButton.buttonWithType(.System) as! UIButton

    private var timePeriod: NSTimeInterval = 0.0
    private var timePeriodsArray: [NSTimeInterval] = [1800, 3600, 0]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func configureForTimePeriod(timePeriod: NSTimeInterval) {
        self.timePeriod = timePeriod
        let minutes = Int(timePeriod/60)
        
        timeButton.setTitle("\(minutes) min")
    }
    
    // MARK: Actions
    
    func didTapFirstPeriodButton(sender: UIButton) {
        delegate?.didChooseTimePeriod(timePeriodsArray[0])
    }
}

private extension BookingTimesView {
    
    func commonInit() {
        
        timeButton.titleLabel?.font = .boldSystemFontOfSize(17.0)
        timeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        timeButton.addTarget(self, action: Selector("didTapFirstPeriodButton:"))
        addSubview(timeButton)
        
        defineConstraints()
    }
    
    func defineConstraints() {
        
        layout(timeButton) { button in
            
            button.width == 90
            button.height == 30//button.superview!.height - 10
            button.center == button.superview!.center
        }
    }
}
