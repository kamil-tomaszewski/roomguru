//
//  ViewController.swift
//  Project
//
//  Copyright (c) 2015 Netguru Sp. z o.o.All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if ENV_DEVELOPMENT
            println("This is running in development scheme");
        #endif
        
        label = UILabel()
        label.text = "Hello, worldguru!";
        label.textAlignment = .Center
        label.accessibilityLabel = "Hello, worldguru!";
        self.view.addSubview(label)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        label.frame = self.view.frame
    }

}

