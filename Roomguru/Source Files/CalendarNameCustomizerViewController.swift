//
//  CalendarNameCustomizerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol CalendarNameCustomizerViewControllerDelegate{
    func calendarNameCustomizerViewController(controller:CalendarNameCustomizerViewController, didEndEditngWithNewName name: String?, forIndexPath indexPath: NSIndexPath?)
}

class CalendarNameCustomizerViewController: UIViewController {
    
    weak var aView: CalendarNameCustomizerView?
    var delegate: CalendarNameCustomizerViewControllerDelegate?
    let name: String?
    let indexPath: NSIndexPath?
    
    // MARK: View life cycle
    
    init(name: String?, indexPath: NSIndexPath) {
        self.name = name
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        aView = loadViewWithClass(CalendarNameCustomizerView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Customize name", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .Plain, target: self, action: Selector("didTapSaveBarButtonItem:"))
        
        hideBackBarButtonTitle()
        aView?.textField.placeholder = name
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        aView?.textField.becomeFirstResponder()
    }
}

// MARK: UIControl methods

extension CalendarNameCustomizerViewController {
    
    func didTapSaveBarButtonItem(sender: UIBarButtonItem) {
        
        if aView?.textField.text.utf16Count > 0 {
            delegate?.calendarNameCustomizerViewController(self, didEndEditngWithNewName: aView?.textField.text, forIndexPath: self.indexPath)
            navigationController?.popViewControllerAnimated(true)
        } else {
            UIAlertView(title: NSLocalizedString("Oh no!", comment: ""), message: NSLocalizedString("Provided name should have at least 1 sign", comment: "")).show()
        }
    }
}
