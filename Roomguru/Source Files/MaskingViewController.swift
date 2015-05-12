//
//  MaskingViewController.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/05/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit

class MaskingViewController: UIViewController {
    
    weak var aView: MaskingView!
    
    private let contentViewController: UIViewController
    
    init(contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        aView = loadViewWithClass(MaskingView.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var frame = aView.contentView.frame
        frame.origin.x = 0
        frame.origin.y = 0
        contentViewController.view.frame = frame
        
        addChildViewController(contentViewController)
        aView.contentView.addSubview(contentViewController.view)
        contentViewController.didMoveToParentViewController(self)        
    }
}
