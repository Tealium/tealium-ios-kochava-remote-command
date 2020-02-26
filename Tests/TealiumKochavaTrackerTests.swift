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
    var kochavaCommand: KochavaCommand!
    var remoteCommand: TealiumRemoteCommand!

    override func setUp() {
        kochavaCommand = KochavaCommand(tealKochavaTracker: mockTealiumKochavaTracker)
        remoteCommand = kochavaCommand.remoteCommand()
    }

    override func tearDown() { }

    func testConfigureWithAttributionDelegate() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
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
        let expect = expectation(description: "Kochava configure(parameters:) method run")
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
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "configure",
            "app_guid": "test", "sleep_tracker": true]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sleepCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testInvalidate() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "configure,invalidate",
            "app_guid": "test"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.invalidateCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithOutData() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "custom",
            "customEventNameString": "someEventName"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendEventTypeEnumWithStandardData() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "addtocart",
            "contentIdString": "123sdf"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventWithStandardDataCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithInfoString() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "custom",
            "customEventNameString": "someEventName",
            "infoString": "blahBlah"]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventWithInfoStringCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendCustomEventWithInfoDictionary() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
        let payload: [String: Any] = ["command_name": "custom",
            "customEventNameString": "someEventName",
            "infoDictionary": ["blahBlah": "test123", "tacos": "cheetos"]]

        if let response = HttpTestHelpers.createRemoteCommandResponse(commandId: "kochava", payload: payload) {
            remoteCommand.remoteCommandCompletion(response)
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sendEventWithInfoDictionaryCount)
        }

        expect.fulfill()
        wait(for: [expect], timeout: 2.0)
    }

    func testSendIdentityLink() {
        let expect = expectation(description: "Kochava configure(parameters:) method run")
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
        let expect = expectation(description: "Kochava configure(parameters:) method run")
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

    func testRetrieveProperties() {
        let expected = ["firstName", "lastName", "companyName", "address", "city", "county", "state", "zip", "phone1", "phone2", "email", "web"]
        let actual = tealKochavaTracker.retrieveProperties(from: MockKochavaEvent.self)
        XCTAssertEqual(expected, actual)
    }
    
    func testSendEventWhenUnrecognizedVarsAreInPayload() {
        let data: [String: Any] = ["nameString": "stuff", "orderIdString": "abc123", "quantityDoubleNumber": 2.0, "priceDoubleNumber": 27.99, "currencyString": "USD", "contentIdString": "234", "micky": "mouse", "daffy": "duck", "dictionary": ["stuff": "yep", "moreStuff": "doubleYep", "moreNested": ["true": "dat"]], "weird": 235.56, "hmm": "{\"1\":\"2\"}", "isCool": true, "uhhh": 123, "specialChars": "$$%^NK@!%)#$@*%AG*DF*@&# 4234!$Q)*(($)(&(!&*~#*!(#*!@)~!*_%(_) )*(GS(FDG&SDFG(FG+__#@+@+@++#+#+##++%$++^^@_#_$()'''33'3'3"]
        
        tealKochavaTracker.sendEvent(type: .purchase, with: data)
        
        XCTAssertTrue(true)
    }

}
