//
//  KeyboardPresenceHandler.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 27/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

protocol KeyboardPresenceHandlerDelegate {
    func firstReponderForHandler(handler: KeyboardPresenceHandler) -> UIView?
}

class KeyboardPresenceHandler {
    
    var delegate: KeyboardPresenceHandlerDelegate?
    
    private let scrollView: UIScrollView
    private let keyboardOffset: CGFloat = 80.0
    
    private var currentResponder: UIView?
    private var currentKeyboardProperties: KeyboardProperties?
    
    private var originalOffset: CGPoint?
    private var originalInsets: UIEdgeInsets?
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: "didChangeFirstResponderNotification:", name: UITextFieldTextDidBeginEditingNotification, object: nil)
        notificationCenter.addObserver(self, selector: "didChangeFirstResponderNotification:", name: UITextViewTextDidBeginEditingNotification, object: nil)
    }
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UITextFieldTextDidBeginEditingNotification, object: nil)
        notificationCenter.removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        originalOffset = scrollView.contentOffset
        originalInsets = scrollView.contentInset
        
        if let userInfo = notification.userInfo {
            currentKeyboardProperties = KeyboardProperties(info: userInfo)
        }
        
        if let responder = currentResponder {
            scrollToResponder(responder, withKeyboardProperties: currentKeyboardProperties!)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo, offset = originalOffset, insets = originalInsets {
            let keyboardProperties = KeyboardProperties(info: userInfo)
            
            animate(keyboardProperties, animations: {
                self.scrollView.contentOffset = offset
                self.scrollView.contentInset = insets
            })
        }
        
        originalOffset = nil
        currentKeyboardProperties = nil
        currentResponder = nil
    }
    
    @objc func didChangeFirstResponderNotification(notification: NSNotification) {
        let actualResponder = delegate?.firstReponderForHandler(self)
        
        if let responder = actualResponder where currentResponder != responder {
            currentResponder = responder
            
            if let properties = currentKeyboardProperties {
                scrollToResponder(responder, withKeyboardProperties: properties)
            }
        }
    }
}

// MARK: Private

private extension KeyboardPresenceHandler {

    func scrollToResponder(responder: UIView, withKeyboardProperties properties: KeyboardProperties) {
        
        var animations: VoidBlock!
        let responderConvertedFrame = responder.convertFrameToView(scrollView)
        
        var contentOffsetDiff: CGFloat = 0.0
        
        if let originalOffset = originalOffset {
            contentOffsetDiff = scrollView.contentOffset.y - originalOffset.y
        }
        
        let respondersMaxY = responderConvertedFrame.maxY
        let keyboardMinY = properties.endFrame.minY
        
        if respondersMaxY - contentOffsetDiff >= keyboardMinY { // Responder is behind the keyboard
            let diff = (respondersMaxY - keyboardMinY) + keyboardOffset
            animate(properties, animations: {
                self.scrollView.contentOffset.increaseYBy(diff)
                self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, diff, 0)
            })
            
        } else if respondersMaxY >= keyboardMinY { // Responder has changed and would be behind the keyboard
            let diff = keyboardMinY - respondersMaxY + keyboardOffset
            
            if var originalOffset = originalOffset {
                originalOffset.increaseYBy(diff)
                animate(properties, animations: {
                    self.scrollView.contentOffset = originalOffset
                    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, diff, 0)
                })
            }
        }
    }
    
    func animate(properties: KeyboardProperties, animations: () -> Void, completion: (Bool) -> Void = { bool in }) {
        let duration = properties.animationDuration
        let curve = properties.animationCurve
        let delay: NSTimeInterval = 0.0
        
        UIView.animateWithDuration(duration, delay: delay, options: curve, animations: animations, completion: completion)
    }
}

// MARK: KeyboardProperties struct

private struct KeyboardProperties {
    private(set) var beginFrame = CGRectZero
    private(set) var endFrame = CGRectZero
    private(set) var animationDuration: NSTimeInterval = 0.0
    private(set) var animationCurve = UIViewAnimationOptions.CurveLinear
    
    init(info: [NSObject: AnyObject]) {
        beginFrame = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        endFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let intCurve = (info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedLongValue
        self.animationCurve = UIViewAnimationOptions(rawValue: intCurve)
    }
}
