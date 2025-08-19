//
//  KochavaInstanceTests.swift
//  TealiumKochavaTests
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import XCTest

@testable import TealiumKochava
import KochavaNetworking
import KochavaMeasurement
import KochavaTracking
import TealiumRemoteCommands

class KochavaInstanceTests: XCTestCase {

    var mockKochavaInstance = MockKochavaInstance()
    var tealKochavaTracker = KochavaInstance()
    var kochavaCommand: KochavaRemoteCommand!

    override func setUp() {
        mockKochavaInstance = MockKochavaInstance() // Reset mock instance between tests
        kochavaCommand = KochavaRemoteCommand(kochavaInstance: mockKochavaInstance)
    }

    override func tearDown() { }
}

// MARK: - onReady Tests
extension KochavaInstanceTests {
    func testOnReady() {
        kochavaCommand.onReady { }  
        XCTAssertTrue(mockKochavaInstance.didCallOnReady)  
    }

    func testOnReadyCalledAfterInitialize() {
        let onReadyIsCalled = expectation(description: "onReady is called")
        let command = KochavaRemoteCommand(kochavaInstance: KochavaInstance())
        command.onReady {
            onReadyIsCalled.fulfill()
        }
        command.processRemoteCommand(with: ["command_name": "initialize", "app_guid": "test"])
        waitForExpectations(timeout: 3.0)
    }
}

// MARK: - processRemoteCommand Tests
extension KochavaInstanceTests {
    func testLoglevel() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "log_level": "debug"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
    }

    func testSetLogLevel() {
        // Log level can only be set during initialization in Kochava v8+
        let payload: [String: Any] = ["command_name": "initialize", "app_guid": "test", "log_level": "debug"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
    }

    func testInitialize() {
        let payload: [String: Any] = ["command_name": "initialize", "app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
    }

    func testInitializeWithSleep() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test", "sleep_tracker": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
    }

    func testInitializeWithIdentityLink() {
        let payload: [String: Any] = ["command_name": "initialize",
                                      "app_guid": "test",
                                      "identity_link_ids": ["email": "test@tealium.com"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.sendIdentityLinkCount)
    }

    func testLimitAdTracking() {
        let payload: [String: Any] = ["command_name": "enableapplimitadtracking", "limit_ad_tracking": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.limitAdTrackingCount)
    }

    func testSetAppLimitAdTracking() {
        let payload: [String: Any] = ["command_name": "setapplimitadtracking", "limit_ad_tracking": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.limitAdTrackingCount)
    }

    func testSendCustomEvent() {
        let payload: [String: Any] = ["command_name": "customEvent", "event": ["name": "test"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        // Kochava SDK konwertuje nazwy eventów na lowercase
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["customevent"])
    }

    func testSendCustomEventWithParameters() {
        let payload: [String: Any] = ["command_name": "customEventWithParams", 
                                      "event": ["name": "test", "currency": "USD", "price_double": 9.99]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        // Kochava SDK konwertuje nazwy eventów na lowercase
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["customeventwithparams"])
    }

    func testSendPredefinedEvent() {
        let payload: [String: Any] = ["command_name": "purchase", "event": ["currency": "USD", "price_double": 19.99]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["predefinedEvent"])
    }

    func testSendIdentityLink() {
        let payload: [String: Any] = ["command_name": "sendidentitylink",
                                      "identity_link_ids": ["email": "test@tealium.com"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendIdentityLinkCount)
    }

    func testSendEventDirectly() {
        let payload: [String: Any] = ["command_name": "testevent"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["testevent"])
    }

    func testSendEventWithEventParameters() {
        let payload: [String: Any] = ["command_name": "testevent",
                                      "event": ["name": "test", "description": "test event"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["testevent"])
    }

    func testSleepTracker() {
        let payload: [String: Any] = ["command_name": "sleeptracker", "sleep_tracker": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sleepTrackerCount)
    }

    func testEventLookup() {
        // "view" jest predefined event w KochavaConstants.eventTypes
        let payload: [String: Any] = ["command_name": "view"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["predefinedEvent"])
    }

    func testEventLookupMultipleEvents() {
        let payload: [String: Any] = ["command_name": "view"]
        kochavaCommand.processRemoteCommand(with: payload)
        kochavaCommand.processRemoteCommand(with: payload)
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(3, self.mockKochavaInstance.eventLookup["predefinedEvent"])
    }

    func testEventLookupMultipleDifferentEvents() {
        let payload: [String: Any] = ["command_name": "view"]
        let payload2: [String: Any] = ["command_name": "purchase"]
        kochavaCommand.processRemoteCommand(with: payload)
        kochavaCommand.processRemoteCommand(with: payload2)
        kochavaCommand.processRemoteCommand(with: payload)
        // Both "view" and "purchase" are predefined events, so they both map to "predefinedEvent"
        XCTAssertEqual(3, self.mockKochavaInstance.eventLookup["predefinedEvent"]) // 2 view + 1 purchase = 3 total
    }

    func testEventLookupWithDictionary() {
        let payload: [String: Any] = ["command_name": "view",
                                      "event": ["test": "test"]]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.eventLookup["predefinedEvent"])
    }

    func testEventLookupWithDictionaryMultipleTimes() {
        let payload: [String: Any] = ["command_name": "view",
                                      "event": ["test": "test"]]
        kochavaCommand.processRemoteCommand(with: payload)
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(2, self.mockKochavaInstance.eventLookup["predefinedEvent"])
    }
    
    func testAppTrackingTransparency() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "app_tracking_transparency_enabled": true,
            "att_authorization_wait_time": 30.0,
            "att_auto_request_authorization": false
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.setAppTrackingTransparencyCount)
        XCTAssertEqual(true, self.mockKochavaInstance.lastATTEnabled)
        XCTAssertEqual(30.0, self.mockKochavaInstance.lastATTWaitTime)
        XCTAssertEqual(false, self.mockKochavaInstance.lastATTAutoRequest)
    }
    
    func testInvalidateCommand() {
        let payload: [String: Any] = ["command_name": "invalidate"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.invalidateCount)
    }
    
    func testEventParameterMapping() {
        let payload: [String: Any] = [
            "command_name": "purchase",
            "event": [
                "currency": "USD",
                "price_double": 29.99,
                "quantity": 2,
                "name": "Test Product",
                "description": "A test product"
            ]
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.lastSentEvents.count)
        
        let sentEvent = self.mockKochavaInstance.lastSentEvents.first!
        XCTAssertEqual("USD", sentEvent.currencyString)
        XCTAssertEqual(29.99, sentEvent.priceDoubleNumber?.doubleValue)
        XCTAssertEqual(2, sentEvent.quantityDoubleNumber?.doubleValue)
        XCTAssertEqual("Test Product", sentEvent.nameString)
        XCTAssertEqual("A test product", sentEvent.descriptionString)
    }
    
    func testLogLevelConfiguration() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "log_level": "debug"
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
        XCTAssertEqual(Log.Level.debug, self.mockKochavaInstance.lastLogLevel)
    }
    
    func testMultipleCommands() {
        let payload: [String: Any] = ["command_name": "initialize,sleeptracker", "app_guid": "test", "sleep_tracker": true]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(2, self.mockKochavaInstance.sleepTrackerCount) // Called during init + explicit command
    }
}
