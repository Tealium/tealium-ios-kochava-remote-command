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
            XCTAssertEqual(1, self.mockTealiumKochavaTracker.sleepTrackerCount)
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
            "custom_event_name": "someEventName"]

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
            "content_id": "123sdf"]

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
            "custom_event_name": "someEventName",
            "info_string": "blahBlah"]

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
            "custom_event_name": "someEventName",
            "info_dictionary": ["blahBlah": "test123", "tacos": "cheetos"]]

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
    
    func testMapPayload() {
        let testEventParams: [String: Any] = [
        "action": "testaction",
        "ad_campaign_id": "1234",
        "ad_campaign_name": "summer",
        "ad_device_type": "iphone",
        "ad_group_id": "123rtg",
        "ad_group_name": "cool kids",
        "ad_mediation_name": "mmm not sure",
        "ad_network_name": "annoying",
        "placement": "in yo face",
        "ad_size": "medium",
        "ad_type": "all the same",
        "from_apple_watch": false,
        "checkout_as_guest": "true",
        "completed": 1,
        "content_id": "123dfg",
        "content_type": "product",
        "currency": "USD",
        "item_added_from": "registry",
        "level": "10",
        "max_rating_value": 5.0,
        "name": "cheetos",
        "order_id": "123lkj",
        "quantity": 1,
        "origin": "store",
        "price": 10.00,
        "rating_value": 5.0,
        "receipt_id": "abc123",
        "referral_from": "seth",
        "registration_method": "myspace",
        "search_term": "hot cheetos",
        "results": "50000",
        "score": "99999999999",
        "some_other_non_kochava_key1": "hello there1",
        "some_other_non_kochava_key2": "hello there2",
        "some_other_non_kochava_key3": "hello there3",
        "some_other_non_kochava_key4": "hello there4"]
        
        let expected: [String: Any] = [
        "actionString": "testaction",
        "adCampaignIdString": "1234",
        "adCampaignNameString": "summer",
        "adDeviceTypeString": "iphone",
        "adGroupIdString": "123rtg",
        "adGroupNameString": "cool kids",
        "adMediationNameString": "mmm not sure",
        "adNetworkNameString": "annoying",
        "adPlacementString": "in yo face",
        "adSizeString": "medium",
        "adTypeString": "all the same",
        "appleWatchBool": false,
        "checkoutAsGuestString": "true",
        "completedBoolNumber": 1,
        "contentIdString": "123dfg",
        "contentTypeString": "product",
        "currencyString": "USD",
        "itemAddedFromString": "registry",
        "levelString": "10",
        "maxRatingValueDoubleNumber": 5.0,
        "nameString": "cheetos",
        "orderIdString": "123lkj",
        "quantityDoubleNumber": 1,
        "originString": "store",
        "priceDoubleNumber": 10.00,
        "ratingValueDoubleNumber": 5.0,
        "receiptIdString": "abc123",
        "referralFromString": "seth",
        "registrationMethodString": "myspace",
        "searchTermString": "hot cheetos",
        "resultsString": "50000",
        "scoreString": "99999999999"]
        
        let mapped = KochavaEventKeys.lookup.mapPayload(testEventParams)
        
        XCTAssertEqual(expected.count, mapped.count)
        
        XCTAssert(NSDictionary(dictionary: mapped).isEqual(to: expected))
    }
    
    func testSendEventWhenUnrecognizedVarsAreInPayload() {
        let data: [String: Any] = ["nameString": "stuff", "orderIdString": "abc123", "quantityDoubleNumber": 2.0, "priceDoubleNumber": 27.99, "currencyString": "USD", "contentIdString": "234", "micky": "mouse", "daffy": "duck", "dictionary": ["stuff": "yep", "moreStuff": "doubleYep", "moreNested": ["true": "dat"]], "weird": 235.56, "hmm": "{\"1\":\"2\"}", "isCool": true, "uhhh": 123, "specialChars": "$$%^NK@!%)#$@*%AG*DF*@&# 4234!$Q)*(($)(&(!&*~#*!(#*!@)~!*_%(_) )*(GS(FDG&SDFG(FG+__#@+@+@++#+#+##++%$++^^@_#_$()'''33'3'3"]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data),
            let decoded = try? JSONDecoder().decode(KochavaEventKeys.self, from: jsonData) else {
                XCTFail("\(KochavaConstants.errorPrefix) could not encode/decode payload.")
                return
        }
        
        tealKochavaTracker.sendEvent(type: .purchase, with: decoded)
        
        XCTAssertTrue(true)
    }

}


