//
//  UserImageDownloader.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class UserImageDownloader: NSObject, NSURLSessionDownloadDelegate {
    
    private var session: NSURLSession?
    private var completion: ((locationURL: NSURL?) -> Void)?
    
    override init() {
        super.init()
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    // MARK: Public
    
    func downloadFileFromUrl(urlString: String, withCompletion completion: (locationURL: NSURL?) -> Void) {
        
        self.completion = completion
        
        if let url = NSURL(string: urlString) {
            session!.downloadTaskWithURL(url).resume()
        }
    }
    
    // MARK: NSURLSessionDelegate
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        self.completion!(locationURL: location)
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        self.completion!(locationURL: nil)
    }
}


