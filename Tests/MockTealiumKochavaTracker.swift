//
//  MockTealiumKochavaTracker.swift
//  regular-rc-testTests
//
//  Created by Christina S on 2/25/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumKochava
import TealiumRemoteCommands
import TealiumCore

protocol MockKochavaTrackerDelegate: class {
    func tracker(_ tracker: KochavaTrackable,
                 didRetrieveAttributionDictionary attributionDictionary: [AnyHashable: Any])
}


class MockTealiumKochavaTracker: KochavaTrackable {
 
    var configureWithAttributionDelegateCount = 0
    var configureWithoutAttributionDelegateCount = 0
    var configureWithSleepCount = 0
    var sleepTrackerCount = 0
    var invalidateCount = 0
    var sendEventCount = 0
    var sendEventWithStandardDataCount = 0
    var sendEventWithInfoStringCount = 0
    var sendEventWithInfoDictionaryCount = 0
    var sendIdentityLinkCount = 0
    var eventLookup = [String: Int]()
    var attributionDelegateRunCount = 0
    var retrievePropertiesCount = 0
    
    var tealium: Tealium?
    weak var delegate: MockKochavaTrackerDelegate?
    
    func configure(with parameters: [AnyHashable : Any]) {
        if let attribution = parameters[kKVAParamRetrieveAttributionBoolKey] as? Bool, attribution == true  {
           configureWithAttributionDelegateCount += 1
           delegate = self
           triggerAsyncDelegate()
        } else {
            configureWithoutAttributionDelegateCount += 1
        }
    }
    
    func sleepTracker(_ sleep: Bool) {
        sleepTrackerCount += 1
    }
    
    func invalidate() {
        invalidateCount += 1
    }
    
    func sendEvent(name: String) {
        sendEventCount += 1
    }
    
    func sendEvent(name: String, with string: String?) {
        sendEventWithInfoStringCount += 1
    }
    
    func sendEvent(name: String, with dictionary: [String : Any]?) {
        sendEventWithInfoDictionaryCount += 1
    }
    
    func sendEvent(type: KochavaEventTypeEnum, with data: KochavaEventKeys?) {
        sendEventWithStandardDataCount += 1
        incrementSpecificEvent(type)
    }
    
    func sendIdentityLink(with info: [AnyHashable : Any]) {
        sendIdentityLinkCount += 1
    }
    
    func incrementSpecificEvent(_ name: KochavaEventTypeEnum) {
        guard eventLookup[String(name.rawValue)] != nil else {
            eventLookup[String(name.rawValue)] = 1
            return
        }
        eventLookup[String(name.rawValue)]! += 1
    }
    
    func triggerAsyncDelegate() {
        DispatchQueue.global().async {
            self.delegate?.tracker(self, didRetrieveAttributionDictionary: ["test":"test"])
        }
    }
    
    func retrieveProperties<T>(from cls: T.Type) -> [String] where T : KochavaEventProtocol {
        return ["test"]
    }
    
}

extension MockTealiumKochavaTracker: MockKochavaTrackerDelegate {
    func tracker(_ tracker: KochavaTrackable, didRetrieveAttributionDictionary attributionDictionary: [AnyHashable : Any]) {
        attributionDelegateRunCount += 1
    }
}
