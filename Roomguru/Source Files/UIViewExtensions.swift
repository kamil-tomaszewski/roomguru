//
//  UIViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 15/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

extension UIView {
    
    //temp nothing in here
}

func fadeOut<T: UIView>(view: T, duration: NSTimeInterval = 1, animated: Bool = true, completion: (Void -> Void)?) {
    let fadeDuration: NSTimeInterval = animated ? duration : 0
    UIView.animateWithDuration(fadeDuration, animations: { () -> Void in
        view.alpha = 0
    }, completion: { finished in
        if let completion = completion {
            completion()
        }
    })
}
