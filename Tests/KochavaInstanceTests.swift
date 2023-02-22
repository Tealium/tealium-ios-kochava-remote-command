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
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "log_level": "debug"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
    }
    
    
    func testLoglevelNotRun() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.logLevelCount)
    }
    
    func testAttEnabled() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "app_tracking_transparency_enabled": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.attEnabledCount)
    }
    
    
    func testAttEnabledNotRun() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.attEnabledCount)
    }

    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize",
            "app_guid": "test", "retrieve_attribution_data": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
    }
    
    func testInitializeNotRunNoAppGUID() {
        let payload: [String: Any] = ["command_name": "initialize"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(0, self.mockKochavaInstance.startCount)
    }
    
    func testSleepTrackerRun() {
        let payload: [String: Any] = ["command_name": "configure,sleeptracker",
                                      "app_guid": "test", "sleep_tracker": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sleepTrackerCount)
    }
    
    func testSleepTrackerNotRun() {
        let payload: [String: Any] = ["command_name": "configure,sleeptracker",
                                      "app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.sleepTrackerCount)
    }

    func testInvalidate() {
        let payload: [String: Any] = ["command_name": "configure,invalidate",
            "app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.invalidateCount)
    }
    
    func testSendCustomEventWithDictionary() {
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": ["info_dictionary": ["hello": "world"]]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
    }
    
    func testSendCustomEventWithCustomDictionary() {
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "custom": ["hello": "world"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
    }

    func testSendCustomEventWithOutDictionary() {
        let payload: [String: Any] = ["command_name": "custom",
            "custom_event_name": "someEventName"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventNoDictionaryCount)
    }
    
    func testSendEventWithoutDictionary() {
        let payload: [String: Any] = ["command_name": "achievement"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventNoDictionary)
    }

    func testSendEventWithDictionary() {
        let payload: [String: Any] = ["command_name": "addtocart",
                                      "event_parameters": ["content_id": "123sdf"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
    }
    
    func testSendEventWithParamsAndCustomDictionary() {
        let payload: [String: Any] = ["command_name": "addtocart",
                                      "event": ["content_id": "123sdf"], "custom": ["bob": "hope"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
    }
    
    func testSendEventWithOnlyCustomDictionary() {
        let payload: [String: Any] = ["command_name": "addtocart","custom": ["bob": "hope"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventWithDictionary)
    }

    func testSendCustomEventWithInfoDictionary() {
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": [
            "info_dictionary": ["blahBlah": "test123", "tacos": "cheetos"]]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
    }
    
    func testSendCustomEventWithCustom() {
        let payload: [String: Any] = ["command_name": "custom",
                                      "custom_event_name": "someEventName", "event_parameters": [
            "custom": ["blahBlah": "test123", "tacos": "cheetos"]]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendCustomEventWithDictionaryCount)
    }

    func testSendIdentityLink() {
        let payload: [String: Any] = ["command_name": "configure,sendidentitylink",
            "app_guid": "test",
            "identity_link_ids": ["customer_id": "abc123",
                "twittername": "@random_dev"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendIdentityLinkCount)
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
        kochavaCommand.processRemoteCommand(with: payload)
        eventNames.forEach {
            let name = $0.eventType?.nameString
            XCTAssertNotNil(name)
            XCTAssert(1 == self.mockKochavaInstance.eventLookup[name!], "🐙\(name!)")
        }
    }
    
    func testLoggingEnabledSetToTrue() {
        let payload: [String: Any] = ["command_name": "initialize,sendidentitylink",
            "app_guid": "test",
            "log_level": "debug"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertTrue(kochavaCommand.loggingEnabled)
    }
    
    func testLoggingEnabledNotSetToTrue() {
        let payload: [String: Any] = ["command_name": "initialize,sendidentitylink",
            "app_guid": "test",
            "log_level": "info"]
        XCTAssertFalse(kochavaCommand.loggingEnabled) // Should be false initially
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertFalse(kochavaCommand.loggingEnabled)
    }
    
    func testRetrieveProperties() {
        let expected = ["firstName", "lastName", "companyName", "address", "city", "county", "state", "zip", "phone1", "phone2", "email", "web"]
        let actual = tealKochavaTracker.retrieveProperties(from: MockKochavaEvent.self)
        XCTAssertEqual(expected, actual)
    }

}


