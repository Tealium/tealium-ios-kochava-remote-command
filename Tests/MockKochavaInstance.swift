//
//  MockKochavaInstance.swift
//  TealiumKochavaTests
//
//  Copyright © 2020 Tealium. All rights reserved.
//

// Kochava v8+ imports
import KochavaNetworking
import KochavaMeasurement
import KochavaTracking
import TealiumRemoteCommands
import TealiumCore
@testable import TealiumKochava

class MockKochavaInstance: KochavaCommand {
    
    var didCallOnReady = false
    var setAppTrackingTransparencyCount = 0
    var limitAdTrackingCount = 0
    var logLevelCount = 0
    var initializeCount = 0
    var sleepTrackerCount = 0
    var invalidateCount = 0
    var sendEventCount = 0
    var sendIdentityLinkCount = 0
    var eventLookup = [String: Int]()
    
    // Tracking for ATT settings
    var lastATTEnabled: Bool?
    var lastATTWaitTime: TimeInterval?
    var lastATTAutoRequest: Bool?
    
    // Tracking for other settings
    var lastLimitAdTracking: Bool?
    var lastLogLevel: Log.Level?
    var lastSleepTracker: Bool?
    var lastAppGuid: String?
    var lastIdentityLinks: [String: String]?
    var lastSentEvents: [Event] = []
    
    private var onReadyCallbacks: [() -> Void] = []
    
    func setAppTrackingTransparency(enabled: Bool, waitTime: TimeInterval? = nil, autoRequest: Bool? = nil) {
        setAppTrackingTransparencyCount += 1
        lastATTEnabled = enabled
        lastATTWaitTime = waitTime
        lastATTAutoRequest = autoRequest
    }
    
    func setLimitAdTracking(_ limitAdTracking: Bool) {
        limitAdTrackingCount += 1
        lastLimitAdTracking = limitAdTracking
    }
    
    func setLogLevel(_ level: Log.Level) {
        logLevelCount += 1
        lastLogLevel = level
    }
    
    func triggerOnReadyCallbacks() {
        for callback in onReadyCallbacks {
            callback()
        }
    }
    
    func onReady(_ onReady: @escaping () -> Void) {
        didCallOnReady = true
        onReadyCallbacks.append(onReady)
        onReady()
    }
    
    func initialize(appGuid: String) {
        initializeCount += 1
        lastAppGuid = appGuid
        triggerOnReadyCallbacks()
    }
    
    func sleepTracker(_ sleep: Bool) {
        sleepTrackerCount += 1
        lastSleepTracker = sleep
    }
    
    func invalidate() {
        invalidateCount += 1
    }
    
    func send(event: Event) {
        sendEventCount += 1
        lastSentEvents.append(event)
        
        // Track event names for compatibility with old tests
        var eventName: String = "unknown"
        
        if let customName = event.customEventName, !customName.isEmpty {
            eventName = customName
        } else if let nameString = event.nameString, !nameString.isEmpty {
            eventName = nameString
        } else {
            eventName = extractEventTypeName(from: event)
        }
        
        if eventLookup[eventName] != nil {
            eventLookup[eventName]! += 1
        } else {
            eventLookup[eventName] = 1
        }
    }
    
    func sendIdentityLink(with info: [String : String]) {
        sendIdentityLinkCount += 1
        lastIdentityLinks = info
    }
    
    // Helper method to extract event type name from Event object
    private func extractEventTypeName(from event: Event) -> String {
        if let customName = event.customEventName, !customName.isEmpty {
            return customName
        }
        
        return "predefinedEvent"
    }
    

}