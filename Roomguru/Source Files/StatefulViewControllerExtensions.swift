//
//  StatefulViewControllerExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import StatefulViewController

extension StatefulViewController {
    
    func setupPlaceholderViews() {
        emptyView = EmptyView(frame: view.frame)
        errorView = ErrorView(frame: view.frame, target: self, action: Selector("loadData"))
        loadingView = LoadingView(frame: view.frame)
    }    
}
