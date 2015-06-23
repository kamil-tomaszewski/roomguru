//
//  UIViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

enum FadingDirection {
    case In, Out
    
    func alpha() -> CGFloat {
        switch self {
        case .In: return 1.0
        case .Out: return 0.0
        }
    }
}

extension UIView {
    
    func convertFrameToView(view: UIView?) -> CGRect {
        return convertRect(self.frame, toView: view)
    }
    
    func findFirstResponder() -> UIView? {
        if isFirstResponder() {
            return self
        }
        
        for subView in self.subviews {
            if let subView = subView as? UIView {
                if let responder = subView.findFirstResponder() {
                    return responder
                }
            }
        }
        return nil
    }
}

func fade<T: UIView>(direction: FadingDirection, view: T?, duration: NSTimeInterval = 1, animated: Bool = true, completion: VoidBlock?) {
    let fadeDuration: NSTimeInterval = animated ? duration : 0
    
    if view == nil {
        return
    }
    
    UIView.animateWithDuration(fadeDuration, animations: {
        view!.alpha = direction.alpha()
    }, completion: { _ in
        if let completion = completion {
            completion()
        }
    })
}
