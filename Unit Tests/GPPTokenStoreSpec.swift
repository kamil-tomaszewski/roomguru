//
//  GPPTokenStoreSpec.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 02/06/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Nimble
import Quick

class GPPTokenStoreSpec: QuickSpec {
    
    override func spec() {
        
        var sut: GPPTokenStore!

        describe("when newly initialized") {
            
            beforeEach {
                let date = NSDate(timeIntervalSince1970: 100)
                sut = GPPTokenStore(auth: self.mockAuthWithExpirationDate(date))
            }
            
            afterEach {
                sut = nil
            }
            
            it("should have properly set expiration date") {
                let date = NSDate(timeIntervalSince1970: 100)
                expect(sut.tokenExpirationDate).to(equal(date))
            }
            
            it("should have properly set access token") {
                expect(sut.accessToken).to(equal("Fixture Access Token"))
            }

            it("should have properly set authorization header") {
                expect(sut.authorizationHeader()).to(equal("Fixture Token Type Fixture Access Token"))
            }
        }
        
        describe("when refreshing valid token") {

            beforeEach {
                let date = NSDate().dateByAddingTimeInterval(1000)
                sut = GPPTokenStore(auth: self.mockAuthWithExpirationDate(date))
            }
            
            afterEach {
                sut = nil
            }
            
            it("token should not be refreshed") {
                var didRefreshToken = true
                sut.refreshTokenIfNeeded(id: "") { (didRefresh, _) in
                    didRefreshToken = didRefresh
                }
                expect(didRefreshToken).toEventually(beFalse())
            }
            
            it("error should be nil") {
                var refreshError: NSError?
                sut.refreshTokenIfNeeded(id: "") { (_, error) in
                    refreshError = error
                }
                expect(refreshError).toEventually(beNil())
            }
            
            it("access token should be same as previous") {
                var accessToken = ""
                sut.refreshTokenIfNeeded(id: "") { (_, _) in
                    accessToken = sut.accessToken
                }
                expect(accessToken).toEventually(equal("Fixture Access Token"))
            }
        }
        
        describe("when refreshing expired token") {
            
            class MockGPPTokenStoreNetworkCoordinator: GPPTokenStoreNetworkCoordinator {

                override func refreshAccessToken(#parameters: [String: AnyObject], completion: ((tokenInfo: (accessToken: String, expirationDate: NSDate)?, error: NSError?)-> Void)) {

                    let expirationDate = NSDate(timeIntervalSince1970: 1000)
                    let tokenInfo = (accessToken: "Fixture New Access Token", expirationDate: expirationDate)
                    completion(tokenInfo: tokenInfo, error: nil)
                }
            }
            
            beforeEach {
                let date = NSDate().dateByAddingTimeInterval(-1000)
                sut = GPPTokenStore(auth: self.mockAuthWithExpirationDate(date))
                sut.networkCoordinator = MockGPPTokenStoreNetworkCoordinator()
            }
            
            afterEach {
                sut = nil
            }
            
            it("token should be refreshed") {
                var didRefreshToken = false
                sut.refreshTokenIfNeeded(id: "") { (didRefresh, _) in
                    didRefreshToken = didRefresh
                }
                expect(didRefreshToken).toEventually(beTrue())
            }
            
            it("error should be nil") {
                var refreshError: NSError?
                sut.refreshTokenIfNeeded(id: "") { (_, error) in
                    refreshError = error
                }
                expect(refreshError).toEventually(beNil())
            }
            
            it("access token should be new") {
                var accessToken = ""
                sut.refreshTokenIfNeeded(id: "") { (_, _) in
                    accessToken = sut.accessToken
                }
                expect(accessToken).toEventually(equal("Fixture New Access Token"))
            }
            
            it("should set new expiration date") {
                sut.refreshTokenIfNeeded(id: "") { (_, _) in }
                expect(sut.tokenExpirationDate).toEventually(equal(NSDate(timeIntervalSince1970: 1000)))
            }
        }
        
        describe("when during refreshing an error occured") {
            
            class MockGPPTokenStoreNetworkCoordinator: GPPTokenStoreNetworkCoordinator {
                
                override func refreshAccessToken(#parameters: [String: AnyObject], completion: ((tokenInfo: (accessToken: String, expirationDate: NSDate)?, error: NSError?)-> Void)) {
                    
                    let error = NSError(message: "Fixture Error Message")
                    completion(tokenInfo: nil, error: error)
                }
            }
            
            var tokenExpirationDate = NSDate().dateByAddingTimeInterval(-1000)
            
            beforeEach {
                sut = GPPTokenStore(auth: self.mockAuthWithExpirationDate(tokenExpirationDate))
                sut.networkCoordinator = MockGPPTokenStoreNetworkCoordinator()
            }
            
            afterEach {
                sut = nil
            }
            
            it("token should not be refreshed") {
                var didRefreshToken = true
                sut.refreshTokenIfNeeded(id: "") { (didRefresh, _) in
                    didRefreshToken = didRefresh
                }
                expect(didRefreshToken).toEventually(beFalse())
            }
            
            it("error should not be nil") {
                var refreshError: NSError?
                
                waitUntil { done in
                    sut.refreshTokenIfNeeded(id: "") { (_, error) in
                        refreshError = error
                        done()
                    }
                }
                expect(refreshError).toNot(beNil())
            }
            
            it("access token should be same as previous") {
                var accessToken = ""
                sut.refreshTokenIfNeeded(id: "") { (_, _) in
                    accessToken = sut.accessToken
                }
                expect(accessToken).toEventually(equal("Fixture Access Token"))
            }
            
            it("should set new expiration date") {
                sut.refreshTokenIfNeeded(id: "") { (_, _) in }
                expect(sut.tokenExpirationDate).to(equal(tokenExpirationDate))
            }
        }
    }
}

private extension GPPTokenStoreSpec {
    
    func mockAuthWithExpirationDate(date: NSDate) -> GTMOAuth2Authentication {
        
        let auth = GTMOAuth2Authentication()
        auth.accessToken = "Fixture Access Token"
        auth.expirationDate = date
        auth.tokenType = "Fixture Token Type"
        auth.refreshToken = "Fixture Refresh Token"
        
        return auth
    }
}
