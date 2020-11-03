//
//  KochavaInstanceTests.swift
//  TealiumKochavaTests
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import XCTest
@testable import TealiumKochava
import KochavaTracker
import TealiumRemoteCommands

class KochavaInstanceTests: XCTestCase {

    var mockKochavaInstance = MockKochavaInstance()
    var tealKochavaTracker = KochavaInstance()
    var kochavaCommand: KochavaRemoteCommand!

    override func setUp() {
        kochavaCommand = KochavaRemoteCommand(kochavaInstance: mockKochavaInstance)
    }

    override func tearDown() { }
    
    func testLoglevel() {
        let expect = expectation(description: "testLoglevel")
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "log_level": "debug"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    
    func testLoglevelNotRun() {
        let expect = expectation(description: "testLoglevelNotRun")
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(0, self.mockKochavaInstance.logLevelCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    func testAttEnabled() {
        let expect = expectation(description: "testAttEnabled")
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "app_tracking_transparency_enabled": true]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.attEnabledCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    
    func testAttEnabledNotRun() {
        let expect = expectation(description: "testAttEnabledNotRun")
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(0, self.mockKochavaInstance.attEnabledCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5.0)
    }

    func testInitialize() {
        let expect = expectation(description: "testInitialize")
        let payload: [String: Any] = ["command_name": "initialize",
            "app_guid": "test", "retrieve_attribution_data": true]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testInitializeNotRunNoAppGUID() {
        let expect = expectation(description: "testInitializeAndStartNotRunNoAppGUID")
        let payload: [String: Any] = ["command_name": "initialize"]
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(0, self.mockKochavaInstance.initializeCount)
            XCTAssertEqual(0, self.mockKochavaInstance.startCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSleepTrackerRun() {
        let expect = expectation(description: "testInvalidate")
        let payload: [String: Any] = ["command_name": "configure,sleeptracker",
                                      "app_guid": "test", "sleep_tracker": true]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sleepTrackerCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSleepTrackerNotRun() {
        let expect = expectation(description: "testInvalidate")
        let payload: [String: Any] = ["command_name": "configure,sleeptracker",
                                      "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(0, self.mockKochavaInstance.sleepTrackerCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testInvalidate() {
        let expect = expectation(description: "testInvalidate")
        let payload: [String: Any] = ["command_name": "configure,invalidate",
            "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.invalidateCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendCustomEventWithDictionary() {
        let expect = expectation(description: "testSendCustomEventWithOutDictionary")
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": ["info_dictionary": ["hello": "world"]]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendCustomEventWithCustomDictionary() {
        let expect = expectation(description: "testSendCustomEventWithOutDictionary")
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "custom": ["hello": "world"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithOutDictionary() {
        let expect = expectation(description: "testSendCustomEventWithOutDictionary")
        let payload: [String: Any] = ["command_name": "custom",
            "custom_event_name": "someEventName"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventNoDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendEventWithoutDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithoutDictionary")
        let payload: [String: Any] = ["command_name": "achievement"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendEventNoDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendEventWithDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithDictionary")
        let payload: [String: Any] = ["command_name": "addtocart",
                                      "event_parameters": ["content_id": "123sdf"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendEventWithParamsAndCustomDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithDictionary")
        let payload: [String: Any] = ["command_name": "addtocart",
                                      "event": ["content_id": "123sdf"], "custom": ["bob": "hope"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendEventWithOnlyCustomDictionary() {
        let expect = expectation(description: "testSendEventTypeEnumWithDictionary")
        let payload: [String: Any] = ["command_name": "addtocart","custom": ["bob": "hope"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithInfoDictionary() {
        let expect = expectation(description: "testSendCustomEventWithInfoDictionary")
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": [
            "info_dictionary": ["blahBlah": "test123", "tacos": "cheetos"]]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testSendCustomEventWithCustom() {
        let expect = expectation(description: "testSendCustomEventWithInfoDictionary")
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": [
            "custom": ["blahBlah": "test123", "tacos": "cheetos"]]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
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

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertEqual(1, self.mockKochavaInstance.sendIdentityLinkCount)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLogLevelFrom() {
        let logLevels = ["never","error","warn","info","debug","trace","always"]
        let expected: [KVALogLevel] = [.never,.error,.warn,.info,.debug,.trace,.always]
        let actual: [KVALogLevel] = logLevels.map {
            KVALogLevel.from(string: $0)
        }
        XCTAssertEqual(actual, expected)
    }

    func testKVAEventCreateFromCommands() {
        let expect = expectation(description: "testEventNamesSentFromCommands")
        let eventNames: [KVAEvent] = [KVAEvent(type: .achievement),
                                      KVAEvent(type: .adClick),
                                      KVAEvent(type: .addToCart),
                                      KVAEvent(type: .addToWishList),
                                      KVAEvent(type: .adView),
                                      KVAEvent(type: .checkoutStart),
                                      KVAEvent(type: .consentGranted),
                                      KVAEvent(type: .levelComplete),
                                      KVAEvent(type: .purchase),
                                      KVAEvent(type: .pushOpened),
                                      KVAEvent(type: .pushReceived),
                                      KVAEvent(type: .rating),
                                      KVAEvent(type: .search),
                                      KVAEvent(type: .startTrial),
                                      KVAEvent(type: .subscribe),
                                      KVAEvent(type: .tutorialComplete),
                                      KVAEvent(type: .view)]
        let commands = "configure,addtocart,achievement,levelcomplete,purchase,checkoutstart,rating,search,registrationcomplete,tutorialcomplete,view,adview,pushrecieved,pushopened,consentgranted,subscribe,starttrial,adclick,addtowishlist"
        

        let payload: [String: Any] = ["command_name": commands, "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            eventNames.forEach {
                XCTAssert(1 == self.mockKochavaInstance.eventLookup[$0.eventNameString()], "🐙\($0.eventNameString())")
            }
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLoggingEnabledSetToTrue() {
        let expect = expectation(description: "testLoggingEnabledSetToTrue")
        let payload: [String: Any] = ["command_name": "initialize,sendidentitylink",
            "app_guid": "test",
            "log_level": "debug"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
            XCTAssertTrue(kochavaCommand.loggingEnabled)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }
    
    func testLoggingEnabledNotSetToTrue() {
        let expect = expectation(description: "testLoggingEnabledNotSetToTrue")
        let payload: [String: Any] = ["command_name": "initialize,sendidentitylink",
            "app_guid": "test",
            "log_level": "info"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        if let response = HttpTestHelpers.createRemoteCommandResponse(type: .webview, commandId: "kochava", payload: payload) {
            kochavaCommand.completion(response)
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


