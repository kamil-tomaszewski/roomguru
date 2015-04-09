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
    
    let firstPeriodButton = UIButton.buttonWithType(.System) as! UIButton
    let secondPeriodButton = UIButton.buttonWithType(.System) as! UIButton
    let thirdPeriodButton = UIButton.buttonWithType(.System) as! UIButton
    
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
        let title = "\(minutes) min"

        firstPeriodButton.hidden = false
        secondPeriodButton.hidden = false
        firstPeriodButton.setTitle("30 min", forState: .Normal)

        if minutes == 30 {
            firstPeriodButton.hidden = true
        }
        
        if minutes <= 60 {
            timePeriodsArray[1] = timePeriod
            secondPeriodButton.setTitle(title, forState: .Normal)
            thirdPeriodButton.hidden = true
        }
        
        if minutes >= 60 {
            timePeriodsArray[1] = 3600
            timePeriodsArray[2] = timePeriod
            secondPeriodButton.setTitle("60 min", forState: .Normal)
            thirdPeriodButton.setTitle(title, forState: .Normal)
            thirdPeriodButton.hidden = false
        }
    }
    
    // MARK: Actions
    
    func didTapFirstPeriodButton(sender: UIButton) {
        delegate?.didChooseTimePeriod(timePeriodsArray[0])
    }
    
    func didTapSecondPeriodButton(sender: UIButton) {
        delegate?.didChooseTimePeriod(timePeriodsArray[1])
    }
    
    func didTapThirdPeriodButton(sender: UIButton) {
        delegate?.didChooseTimePeriod(timePeriodsArray[2])
    }
    
    // MARK: Private
    
    private func commonInit() {
        configure()
        addSubview(firstPeriodButton)
        addSubview(secondPeriodButton)
        addSubview(thirdPeriodButton)
        defineConstraints()
    }
    
    private func defineConstraints() {
        
        layout(firstPeriodButton, secondPeriodButton, thirdPeriodButton) { _first, _second, _third in
            
            _first.width == 90
            
            _first.right == _second.left
            _third.left == _second.right
            
            _first.width == _second.width
            _second.width == _third.width
            
            _first.centerY == _first.superview!.centerY
            _second.center == _second.superview!.center
            _third.centerY == _third.superview!.centerY
            
            return
        }
    }
    
    private func configure() {
        let font = UIFont.boldSystemFontOfSize(17.0)
        let white = UIColor.whiteColor()
       
        firstPeriodButton.titleLabel?.font = font
        secondPeriodButton.titleLabel?.font = font
        thirdPeriodButton.titleLabel?.font = font
        
        firstPeriodButton.setTitleColor(white, forState: .Normal)
        secondPeriodButton.setTitleColor(white, forState: .Normal)
        thirdPeriodButton.setTitleColor(white, forState: .Normal)
        
        firstPeriodButton.addTarget(self, action: Selector("didTapFirstPeriodButton:"))
        secondPeriodButton.addTarget(self, action: Selector("didTapSecondPeriodButton:"))
        thirdPeriodButton.addTarget(self, action: Selector("didTapThirdPeriodButton:"))
    }
    
}
