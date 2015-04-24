//
//  UserDiskManagerSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Roomguru

class UserDiskManagerSpec: QuickSpec {
    override func spec() {
        
        let fileID = "FixtureFileID"
        var sut: UserDiskManager? = UserDiskManager()
        
        beforeEach {
            sut = UserDiskManager()
        }
        
        afterEach {
            NSFileManager.defaultManager().removeItemAtPath(sut!.profileDirectoryPath.stringByAppendingPathComponent(fileID), error: nil)
            sut = nil
        }
        
        describe("when newly created") {
            
            it("should have no file saved on disk") {
                expect(sut!.existFileWithIdentifier(fileID)).to(beFalse())
            }
        }
        
        context("when saved file on disk") {
            
            beforeEach {
                sut!.saveProfileImage(self.createImageOnDiskWithIdentifier(fileID), forIdentifier: fileID)
            }
            
            it("should file be saved on disk in proper directory") {
                expect(sut!.existFileWithIdentifier(fileID)).to(beTrue())
            }
            
            it("shouldn't file exist in temporary directory") {
                let path = NSURL(fileURLWithPath: NSTemporaryDirectory() + fileID)!.path!
                let exist = NSFileManager.defaultManager().fileExistsAtPath(path)
                expect(exist).to(beFalse())
            }
            
            it("should loaded file be same as saved one") {
                let data = sut!.loadProfileImageWithIdentifier(fileID)!
                expect(data.length).to(equal(NSData.composeTestImagaDataRepresentation().length))
            }
        }
        
        context("after saving and deleting it") {
            
            beforeEach {
                sut!.saveProfileImage(self.createImageOnDiskWithIdentifier(fileID), forIdentifier: fileID)
                sut!.deleteProfileImageWithIdentifier(fileID)
            }
            
            it("shouldn't file exist in profile directory") {
                expect(sut!.existFileWithIdentifier(fileID)).to(beFalse())
            }
        }
    }
}

private extension UserDiskManagerSpec {
    
    func createImageOnDiskWithIdentifier(identifier: String) -> NSURL {
        let filePath = NSURL(fileURLWithPath: NSTemporaryDirectory() + identifier)!.path!
        NSData.composeTestImagaDataRepresentation().writeToFile(filePath, atomically: true)
        return NSURL(fileURLWithPath: filePath)!
    }
    
    func removeImageFromDiskWithIdentifier(identifier: String) {
        if let filePath = NSURL(fileURLWithPath: NSTemporaryDirectory() + identifier)!.path {
            NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
        }
        
    }
}
