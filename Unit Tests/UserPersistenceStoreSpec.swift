//
//  UserPersistenceStoreSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 24/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

import Roomguru

class UserPersistenceStoreSpec: QuickSpec {
    override func spec() {
        
        var sut: UserPersistenceStore? = UserPersistenceStore.sharedStore
        
        beforeEach {
            sut = UserPersistenceStore.sharedStore
        }
        
        afterEach {
            sut = nil
        }
        
        afterSuite {
            UserPersistenceStore.sharedStore.clear()
        }
        
        describe("when newly initialized") {
            
            it("should be initialized as shared manager") {
                expect(UserPersistenceStore.sharedStore).to(beIdenticalTo(sut))
            }
            
            it("should have no user") {
                expect(sut!.user).to(beNil())
            }
        }
        
        describe("when registering new user") {
            
            beforeEach {
                sut!.registerUserWithEmail("fixture.email@example.com")
            }
            
            it("user should be saved") {
                expect(sut!.user).toNot(beNil())
            }
            
            it("user should have proper email") {
                expect(sut!.user?.email).to(equal("fixture.email@example.com"))
            }
        }
        
        
        describe("when replacing saved user by new one") {
            
            beforeEach {
                sut!.registerUserWithEmail("fixture.email.2@example.com")
            }
            
            it("user should be saved") {
                expect(sut!.user).toNot(beNil())
            }
            
            it("user should have proper email") {
                expect(sut!.user?.email).to(equal("fixture.email.2@example.com"))
            }
            
            it("loaded user should have same email as user stored by persistence store") {
                let storedEmail = sut!.user?.email
                expect(storedEmail).to(equal(sut!.load()?.email))
            }
        }
    
        describe("when deleting stored user") {
            
            beforeEach {
                sut!.clear()
            }
            
            it("user should not exist") {
                expect(sut!.user).to(beNil())
            }
            
            it("loaded user should not exist") {
                expect(sut!.load()).to(beNil())
            }
        }
    }
}
