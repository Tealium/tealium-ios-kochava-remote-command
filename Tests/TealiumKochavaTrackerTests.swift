//
//  TealiumKochavaTrackerTests.swift
//  regular-rc-testTests
//
//  Created by Christina S on 2/25/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumKochava
import TealiumRemoteCommands

class TealiumKochavaTrackerTests: XCTestCase {

    var mockTealiumKochavaTracker = MockTealiumKochavaTracker()
    var tealKochavaTracker = TealiumKochavaTracker()
    var kochavaCommand: KochavaRemoteCommand!
    var remoteCommand: TealiumRemoteCommand!

    override func setUp() {
        kochavaCommand = KochavaRemoteCommand(tealKochavaTracker: mockTealiumKochavaTracker)
        remoteCommand = kochavaCommand.remoteCommand()
    }

    override func tearDown() { }

    func testConfigureWithAttributionDelegate() {
        let expect = expectation(description: "testConfigureWithAttributionDelegate")
        let payload: [String: Any] = ["command_name": "configure",
            "app_guid": "test", "retrieve_attribution_data": true]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.configureWithAttributionDelegateCount)
            
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.attributionDelegateRunCount)
        }
        
        expect.fulfill()
        wait(for: [expect], timeout: 5.0)
    }

    func testConfigureWithoutAttributionDelegate() {
        let expect = expectation(description: "testConfigureWithoutAttributionDelegate")
        let payload: [String: Any] = ["command_name": "configure",
            "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.configureWithoutAttributionDelegateCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testConfigureWithSleep() {
        let expect = expectation(description: "testConfigureWithSleep")
        let payload: [String: Any] = ["command_name": "configure",
            "app_guid": "test", "sleep_tracker": true]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sleepTrackerCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testInvalidate() {
        let expect = expectation(description: "testInvalidate")
        let payload: [String: Any] = ["command_name": "configure,invalidate",
            "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.invalidateCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithOutDictionary() {
        let expect = expectation(description: "testSendCustomEventWithOutDictionary")
        let payload: [String: Any] = ["command_name": "custom",
            "custom_event_name": "someEventName"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendCustomEventNoDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendEventTypeEnumWithoutDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithoutDictionary")
        let payload: [String: Any] = ["command_name": "achievement"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventTypeEnumNoDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendEventTypeEnumWithDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithDictionary")
        let payload: [String: Any] = ["command_name": "addtocart",
                                      "event_parameters": ["content_id": "123sdf"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventTypeEnumWithDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithInfoDictionary() {
        let expect = expectation(description: "testSendCustomEventWithInfoDictionary")
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": [
            "info_dictionary": ["blahBlah": "test123", "tacos": "cheetos"]]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendCustomEventWithDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendIdentityLink() {
        let expect = expectation(description: "testSendIdentityLink")
        let payload: [String: Any] = ["command_name": "configure,sendidentitylink",
            "app_guid": "test",
            "identity_link_ids": ["customer_id": "abc123",
                "twittername": "@random_dev"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendIdentityLinkCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testEventNamesSentFromCommands() {
        let expect = expectation(description: "testEventNamesSentFromCommands")
        let eventNames: [KochavaEventTypeEnum] = [.achievement, .adClick, .addToCart, .addToWishList, .adView, .checkoutStart, .consentGranted, .levelComplete, .purchase, .pushOpened, .pushReceived, .rating, .search, .startTrial, .subscribe, .tutorialComplete, .view]
        let commands = "configure,addtocart,achievement,levelcomplete,purchase,checkoutstart,rating,search,registrationcomplete,tutorialcomplete,view,adview,pushrecieved,pushopened,consentgranted,subscribe,starttrial,adclick,addtowishlist"
        

        let payload: [String: Any] = ["command_name": commands, "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            eventNames.forEach {
                XCTAssert(1 == self.mockTealiumKochavaTracker.eventLookup[String($0.rawValue)], "🐙\(String($0.rawValue))")
            }
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLoggingEnabledSetToTrue() {
        let expect = expectation(description: "testLoggingEnabledSetToTrue")
        let payload: [String: Any] = ["command_name": "configure,sendidentitylink",
            "app_guid": "test",
            "log_level": "debug"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertTrue(kochavaCommand.loggingEnabled)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLoggingEnabledNotSetToTrue() {
        let expect = expectation(description: "testLoggingEnabledNotSetToTrue")
        let payload: [String: Any] = ["command_name": "configure,sendidentitylink",
            "app_guid": "test",
            "log_level": "info"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertFalse(kochavaCommand.loggingEnabled)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testRetrieveProperties() {
        let expected = ["firstName", "lastName", "companyName", "address", "city", "county", "state", "zip", "phone1", "phone2", "email", "web"]
        let actual = tealKochavaTracker.retrieveProperties(from: MockKochavaEvent.self)
        XCTAssertEqual(expected, actual)
    }

}


