//
//  MockKochavaInstance.swift
//  TealiumKochavaTests
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumKochava
import KochavaTracker
import TealiumRemoteCommands
import TealiumCore

class MockKochavaInstance: KochavaCommand {
    
    var attEnabledCount = 0
    var limitAdTrackingCount = 0
    var logLevelCount = 0
    var initializeCount = 0
    var startCount = 0
    var configureWithSleepCount = 0
    var sleepTrackerCount = 0
    var invalidateCount = 0
    var sendCustomEventNoDictionaryCount = 0
    var sendCustomEventWithDictionaryCount = 0
    var sendEventNoDictionary = 0
    var sendEventWithDictionary = 0
    var sendIdentityLinkCount = 0
    var retrievePropertiesCount = 0
    var eventLookup = [String: Int]()
    
    var attEnabled: Bool {
        get {
            return true
        }
        set {
            attEnabledCount += 1
        }
    }
    
    var limitAdTracking: Bool {
        get {
            return true
        }
        set {
            limitAdTrackingCount += 1
        }
    }
    
    var logLevel: String {
        get {
            return "debug"
        }
        set {
            logLevelCount += 1
        }
    }
    
    func initialize(with payload: [String : Any], appGuid: String) {
        initializeCount += 1
    }
    
    func start(with appGuid: String) {
        startCount += 1
    }
    
    func sleepTracker(_ sleep: Bool) {
        sleepTrackerCount += 1
    }
    
    func invalidate() {
        invalidateCount += 1
    }
    
    func sendCustom(event name: String) {
        sendCustomEventNoDictionaryCount += 1
    }
    
    func sendCustom(event name: String, with dictionary: [String : Any]) {
        sendCustomEventWithDictionaryCount += 1
    }
    
    func send(event: KVAEvent) {
        sendEventNoDictionary += 1
        incrementSpecificEvent(event)
    }
    
    func send(event: KVAEvent, with dictionary: [String : Any]) {
        sendEventWithDictionary += 1
        incrementSpecificEvent(event)
    }
    
    func sendIdentityLink(with info: [String : String]) {
        sendIdentityLinkCount += 1
    }
    
    func incrementSpecificEvent(_ event: KVAEvent) {
        guard let nameString = event.eventType?.nameString else {
            return
        }
        guard eventLookup[nameString] != nil else {
            eventLookup[nameString] = 1
            return
        }
        eventLookup[nameString]! += 1
    }
    
    func retrieveProperties<T>(from cls: T.Type) -> [String] where T : KochavaEventProtocol {
        retrievePropertiesCount += 1
        return ["test"]
    }
    
}

