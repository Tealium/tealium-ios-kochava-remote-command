//
//  KochavaInstanceTests.swift
//  TealiumKochavaTests
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import KochavaMeasurement
import KochavaNetworking
import KochavaTracking
import TealiumRemoteCommands
import XCTest

@testable import TealiumKochava

class KochavaInstanceTests: XCTestCase {

    var mockKochavaInstance: MockKochavaInstance!
    var kochavaCommand: KochavaRemoteCommand!

    override func setUp() {
        mockKochavaInstance = MockKochavaInstance()
        kochavaCommand = KochavaRemoteCommand(
            kochavaInstance: mockKochavaInstance
        )
    }

    override func tearDown() {
        mockKochavaInstance = nil
        kochavaCommand = nil
    }
}

// MARK: - onReady Tests
extension KochavaInstanceTests {
    func testOnReady() {
        kochavaCommand.onReady {}
        XCTAssertTrue(mockKochavaInstance.didCallOnReady)
    }

    func testOnReadyCalledAfterInitialize() {
        let onReadyIsCalled = expectation(description: "onReady is called")
        let command = KochavaRemoteCommand(kochavaInstance: KochavaInstance())
        command.onReady {
            onReadyIsCalled.fulfill()
        }
        command.processRemoteCommand(with: [
            "command_name": "initialize", "app_guid": "test",
        ])
        waitForExpectations(timeout: 3.0)
    }
}

// MARK: - processRemoteCommand Tests
extension KochavaInstanceTests {    
    func testLoglevel() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "log_level": "debug",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.logLevelCount)
    }

    func testInitialize() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
    }

    func testInitializeWithIdentityLink() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "identity_link_ids": ["email": "test@tealium.com"],
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.setIdentityLinksCount)
    }

    func testInitializeWithoutAppGuid() {
        let payload: [String: Any] = ["command_name": "initialize"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.initializeCount)
    }

    func testInitializeWithInvalidLogLevel() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "log_level": "invalid_level",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(0, self.mockKochavaInstance.logLevelCount)
    }


    func testConfigurationParams() {
        let configParams: [String: Any] = ["param1": "value1", "param2": 123]
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "configuration_params": configParams,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.configureCount)
        XCTAssertNotNil(self.mockKochavaInstance.lastConfigureObject)
    }

    func testLimitAdTrackingWithInt() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "limit_ad_tracking": 1,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.limitAdTrackingCount)
        XCTAssertEqual(true, self.mockKochavaInstance.lastLimitAdTracking)
    }

    func testSleepWithInt() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "sleep": 0,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.setSleepCount)
        XCTAssertEqual(false, self.mockKochavaInstance.lastSleepTracker)
    }

    func testAppTrackingTransparency() {
        let payload: [String: Any] = [
            "command_name": "initialize",
            "app_guid": "test",
            "app_tracking_transparency_enabled": true,
            "att_authorization_wait_time": 30.0,
            "att_auto_request_authorization": false,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(
            1,
            self.mockKochavaInstance.setAppTrackingTransparencyCount
        )
        XCTAssertEqual(true, self.mockKochavaInstance.lastATTEnabled)
        XCTAssertEqual(30.0, self.mockKochavaInstance.lastATTWaitTime)
        XCTAssertEqual(false, self.mockKochavaInstance.lastATTAutoRequest)
    }

    func testSendCustomEvent() {
        let payload: [String: Any] = [
            "command_name": "customEvent",
            "event": ["name": "test"],
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.lastSentEvents.count)
        XCTAssertNotNil(self.mockKochavaInstance.lastSentEvents.last)
    }

    func testSendCustomEventWithParameters() {
        let payload: [String: Any] = [
            "command_name": "customEventWithParams",
            "event": [
                "name": "test",
                "currency": "USD",
                "price_double": 9.99
            ],
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.lastSentEvents.count)
        XCTAssertNotNil(self.mockKochavaInstance.lastSentEvents.last)
    }

    func testSendIdentityLink() {
        let payload: [String: Any] = [
            "command_name": "setidentitylinks",
            "identity_link_ids": ["email": "test@tealium.com"],
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.setIdentityLinksCount)
    }

    func testInvalidateCommand() {
        let payload: [String: Any] = ["command_name": "invalidate"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.invalidateCount)
    }

    func testMultipleCommands() {
        let payload: [String: Any] = [
            "command_name": "initialize,setsleep",
            "app_guid": "test",
            "sleep": true,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(2, self.mockKochavaInstance.setSleepCount)
    }

    func testSetCustomIdentifiersCommand() {
        let customIdentifiers = [
            "user_id": "12345", "email": "test@example.com",
        ]
        let payload: [String: Any] = [
            "command_name": "setcustomidentifiers",
            "custom_identifiers": customIdentifiers,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.setCustomIdentifiersCount)
        XCTAssertEqual(
            customIdentifiers,
            self.mockKochavaInstance.lastCustomIdentifiers
        )
    }

    func testSetCustomValuesCommand() {
        let customValues: [String: Any] = [
            "level": 5, "score": 1250, "premium": true,
        ]
        let payload: [String: Any] = [
            "command_name": "setcustomvalues",
            "custom_values": customValues,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.setCustomValuesCount)
        XCTAssertNotNil(self.mockKochavaInstance.lastCustomValues)
        XCTAssertEqual(
            5,
            self.mockKochavaInstance.lastCustomValues?["level"] as? Int
        )
        XCTAssertEqual(
            true,
            self.mockKochavaInstance.lastCustomValues?["premium"] as? Bool
        )
    }

    func testStartCommand() {
        let payload: [String: Any] = ["command_name": "start"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.startCount)
    }

    func testStopCommand() {
        let payload: [String: Any] = ["command_name": "stop"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.stopCount)
    }

    func testCreatePrivacyProfileCommand() {
        let profileName = "GDPR_Profile"
        let datapoints = ["device_id", "location", "user_agent"]
        let payload: [String: Any] = [
            "command_name": "createprivacyprofile",
            "privacy_profile_name": profileName,
            "privacy_datapoints": datapoints,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.createPrivacyProfileCount)
        XCTAssertEqual(
            profileName,
            self.mockKochavaInstance.lastPrivacyProfileName
        )
        XCTAssertEqual(
            datapoints,
            self.mockKochavaInstance.lastPrivacyDatapoints
        )
    }

    func testSetPrivacyProfileCommand() {
        let profileName = "CCPA_Profile"
        let payload: [String: Any] = [
            "command_name": "setprivacyprofile",
            "privacy_profile_name": profileName,
            "privacy_enabled": true,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.setPrivacyProfileCount)
        XCTAssertEqual(
            profileName,
            self.mockKochavaInstance.lastPrivacyProfileName
        )
        XCTAssertEqual(true, self.mockKochavaInstance.lastPrivacyEnabled)
    }

    func testSetCustomIdentifiersWithoutDictionary() {
        let payload: [String: Any] = [
            "command_name": "setcustomidentifiers",
            "custom_identifiers": "not_a_dictionary",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.setCustomIdentifiersCount)
    }

    func testSetCustomValuesWithoutDictionary() {
        let payload: [String: Any] = [
            "command_name": "setcustomvalues",
            "custom_values": "not_a_dictionary",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.setCustomValuesCount)
    }

    func testSetIdentityLinksWithoutDictionary() {
        let payload: [String: Any] = [
            "command_name": "setidentitylinks",
            "identity_link_ids": "not_a_dictionary",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.setIdentityLinksCount)
    }

    func testCreatePrivacyProfileWithoutName() {
        let payload: [String: Any] = [
            "command_name": "createprivacyprofile",
            "privacy_datapoints": ["device_id"],
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.createPrivacyProfileCount)
    }

    func testCreatePrivacyProfileWithoutDatapoints() {
        let payload: [String: Any] = [
            "command_name": "createprivacyprofile",
            "privacy_profile_name": "TestProfile",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.createPrivacyProfileCount)
    }

    func testCreatePrivacyProfileWithInvalidDatapoints() {
        let payload: [String: Any] = [
            "command_name": "createprivacyprofile",
            "privacy_profile_name": "TestProfile",
            "privacy_datapoints": "not_an_array",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.createPrivacyProfileCount)
    }

    func testSetPrivacyProfileWithoutName() {
        let payload: [String: Any] = [
            "command_name": "setprivacyprofile",
            "privacy_enabled": true,
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.setPrivacyProfileCount)
    }

    func testLimitAdTrackingWithoutBool() {
        let payload: [String: Any] = [
            "command_name": "setapplimitadtracking",
            "limit_ad_tracking": "not_a_bool",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.limitAdTrackingCount)
    }

    func testSetSleepWithoutBool() {
        let payload: [String: Any] = [
            "command_name": "setsleep",
            "sleep": "not_a_bool",
        ]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.setSleepCount)
    }

    func testEmptyCommandName() {
        let payload: [String: Any] = ["command_name": ""]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(0, self.mockKochavaInstance.sendEventCount)
    }

    func testMissingCommandName() {
        let payload: [String: Any] = ["app_guid": "test"]
        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(0, self.mockKochavaInstance.initializeCount)
    }

    func testAllPredefinedEventTypes() {
        let eventTypes = [
            "achievement", "adclick", "adview", "addtocart", "addtowishlist",
            "checkoutstart", "consentgranted", "custom", "deeplink",
            "levelcomplete",
            "purchase", "pushopened", "pushreceived", "rating",
            "registrationcomplete",
            "search", "starttrial", "subscribe", "tutorialcomplete", "view",
        ]

        for eventType in eventTypes {
            let payload: [String: Any] = ["command_name": eventType]
            kochavaCommand.processRemoteCommand(with: payload)
        }

        XCTAssertEqual(
            eventTypes.count,
            self.mockKochavaInstance.sendEventCount
        )
        XCTAssertEqual(
            eventTypes.count,
            self.mockKochavaInstance.lastSentEvents.count
        )
        for event in self.mockKochavaInstance.lastSentEvents {
            XCTAssertNil(event.customEventName)
        }
    }

    func testEventWithComplexParameters() {
        let eventParams: [String: Any] = [
            "currency": "EUR",
            "price_double": 49.99,
            "quantity": 3,
            "name": "Premium Product",
            "description": "High quality item",
            "date_object": Date(),
            "completed": true,
            "background": false,
            "info_dictionary": ["extra": "data"],
            "unknown_param": "should_be_preserved",
        ]

        let payload: [String: Any] = [
            "command_name": "purchase",
            "event": eventParams,
        ]

        kochavaCommand.processRemoteCommand(with: payload)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)

        let sentEvent = self.mockKochavaInstance.lastSentEvents.first!
        XCTAssertEqual("EUR", sentEvent.currencyString)
        XCTAssertEqual(49.99, sentEvent.priceDoubleNumber?.doubleValue)
        XCTAssertEqual(3, sentEvent.quantityDoubleNumber?.doubleValue)
        XCTAssertEqual("Premium Product", sentEvent.nameString)
        XCTAssertEqual("High quality item", sentEvent.descriptionString)
        XCTAssertNotNil(sentEvent.date)
        XCTAssertEqual(true, sentEvent.completedBoolNumber?.boolValue)
        XCTAssertEqual(false, sentEvent.backgroundBoolNumber?.boolValue)
        XCTAssertNotNil(sentEvent.infoDictionary)

        XCTAssertEqual(
            "should_be_preserved",
            sentEvent.infoDictionary?["unknown_param"] as? String
        )
    }

    func testInvalidCommandInMultipleCommands() {
        let payload: [String: Any] = [
            "command_name": "initialize,invalid_command,start",
            "app_guid": "test",
        ]
        kochavaCommand.processRemoteCommand(with: payload)

        XCTAssertEqual(1, self.mockKochavaInstance.initializeCount)
        XCTAssertEqual(1, self.mockKochavaInstance.startCount)
        XCTAssertEqual(1, self.mockKochavaInstance.sendEventCount)
        XCTAssertEqual(1, self.mockKochavaInstance.lastSentEvents.count)
        XCTAssertEqual(
            "invalid_command",
            self.mockKochavaInstance.lastSentEvents.last?.customEventName
        )
    }
}
