//
//  UserDiskManager.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 13/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

class UserDiskManager {
    
    private let directoryName = "Profile"
    
    init() {
        createDirectoryIfNeeded()
    }
    
    func deleteProfileImageWithIdentifier(identifier: String) {
        
        if let destinationURL = NSURL(fileURLWithPath:pathForIdentifier(identifier)) {
            NSFileManager.defaultManager().removeItemAtURL(destinationURL, error: nil)
        }
    }
    
    func loadProfileImageWithIdentifier(identifier: String) -> NSData? {
        
        return NSData(contentsOfFile: pathForIdentifier(identifier))
    }
    
    func saveProfileImage(temporaryLocation: NSURL, forIdentifier identifier: String) {
        
        if let destinationURL = NSURL(fileURLWithPath: pathForIdentifier(identifier)) {
            if NSFileManager.defaultManager().moveItemAtURL(temporaryLocation, toURL: destinationURL, error: nil) {
                return
            }
        }
        
        // remove
        NSFileManager.defaultManager().removeItemAtURL(temporaryLocation, error: nil)
    }
    
    func existFileWithIdentifier(identifier: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(pathForIdentifier(identifier))
    }
    
    // MARK: Private
    
    private func createDirectoryIfNeeded() {
        var error: NSError?
        let path = directoryPath()
        
        if (!NSFileManager.defaultManager().fileExistsAtPath(path)) {
            NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil, error: &error)
        }
    }
    
    private func directoryPath() -> String {
        let documentsDirectory: AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        return documentsDirectory.stringByAppendingPathComponent(directoryName)
    }
    
    private func pathForIdentifier(identifier: String) -> String {
        return directoryPath().stringByAppendingPathComponent(identifier)
    }
}
