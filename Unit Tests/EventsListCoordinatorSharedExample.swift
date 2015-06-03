//
//  EventsListCoordinatorSharedExample.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 03/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import SwiftyJSON

class EventsListCoordinatorSharedExample: QuickConfiguration {
    
    override class func configure(configuration: Configuration) {
        
        sharedExamples("events coordinator") { (sharedExampleContext: SharedExampleContext) in
            
            var config: [String: AnyObject] = sharedExampleContext() as! [String: AnyObject]
            let sut = config["sut"] as! EventsListCoordinator
            
            // test message:
            let messageDictionary = config["message"] as! [String: AnyObject]
            let hasMessage = !(messageDictionary["isNil"] as! Bool)
            
            if hasMessage {
                
                let expectedMessage = messageDictionary["value"] as! String
                
                it("should return correct message") {
                    sut.loadDataWithCompletion() { (_, message, _) in
                        
                        if let message = message {
                            expect(message).to(equal(expectedMessage))
                        }  else { // make test failing:
                            expect(message).toNot(beNil())
                        }
                    }
                }
                
            } else {
                it("should not have message") {
                    sut.loadDataWithCompletion() { (_, message, _) in
                        expect(message).to(beNil())
                    }
                }
            }
            
            // test icon:
            let iconDictionary = config["icon"] as! [String: AnyObject]
            let hasIcon = !(iconDictionary["isNil"] as! Bool)
            
            if hasIcon {
                
                let expectedIcon = iconDictionary["value"] as! String
                
                it("should return correct icon") {
                    sut.loadDataWithCompletion() { (_, _, icon) in
                        
                        if let icon = icon {
                            expect(String.fontAwesomeIconWithName(icon)).to(equal(expectedIcon))
                        } else { // make test failing:
                            expect(icon).toNot(beNil())
                        }
                    }
                }
                
            } else {
                
                it("should not have icon") {
                    sut.loadDataWithCompletion() { (_, _, icon) in
                        expect(icon).to(beNil())
                    }
                }
            }
            
            // test status:
            let expectedStatus = config["status"] as! String
            
            it("should return correct status") {
                sut.loadDataWithCompletion() { (status, _, _) in
                    expect(status.toString()).to(equal(expectedStatus))
                }
            }
        }
    }
}

private extension ResponseStatus {
    
    func toString() -> String {
        switch self {
        case .Success: return "Success"
        case .Empty: return "Empty"
        case .Failed: return "Failed"
        }
    }
}
