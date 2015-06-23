//
//  CalendarNameCustomizerViewController.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 07/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol CalendarNameCustomizerViewControllerDelegate {
    
    func calendarNameCustomizerViewController(controller:CalendarNameCustomizerViewController, didEndEditngWithNewName name: String?)
    func calendarNameCustomizerViewControllerDidResetName(controller:CalendarNameCustomizerViewController)
}

class CalendarNameCustomizerViewController: UIViewController {
    
    private weak var aView: CalendarNameCustomizerView?
    var delegate: CalendarNameCustomizerViewControllerDelegate?
    var shouldShowResetButton = false
    let name: String?
    
    // MARK: View life cycle
    
    init(name: String?, indexPath: NSIndexPath) {
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = nil
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
        aView?.textField.delegate = self
        aView?.button.addTarget(self, action: Selector("didClickResetButton:"))
        aView?.button.hidden = !shouldShowResetButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        aView?.textField.becomeFirstResponder()
    }
}

// MARK: UIControl methods

extension CalendarNameCustomizerViewController {
    
    func didTapSaveBarButtonItem(sender: UIBarButtonItem) {
        save()
    }
    
    func didClickResetButton(sender: UIButton) {
        delegate?.calendarNameCustomizerViewControllerDidResetName(self)
        navigationController?.popViewControllerAnimated(true)
    }
}

// MARK: UITextFieldDelegate

extension CalendarNameCustomizerViewController: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        save()
        return true
    }
}

private extension CalendarNameCustomizerViewController {

    func save() {
        if aView?.textField.text.lengthByTrimmingWhitespaceCharacters() > 0 {
            delegate?.calendarNameCustomizerViewController(self, didEndEditngWithNewName: aView?.textField.text)
            navigationController?.popViewControllerAnimated(true)
        } else {
            let message = NSLocalizedString("Provided name should have at least 1 sign", comment: "")
            self.presentViewController(UIAlertController(message: message), animated: true, completion: nil)
        }
    }
}
