//
//  ViewController.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit

class RGRViewController: UIViewController {
    
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * CGFloat(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let loginViewController = RGRLoginViewController()
            self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }

}

