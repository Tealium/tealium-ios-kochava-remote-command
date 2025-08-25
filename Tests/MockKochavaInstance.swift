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
    var setSleepCount = 0
    var invalidateCount = 0
    var sendEventCount = 0
    var setIdentityLinksCount = 0
    var setCustomIdentifiersCount = 0
    var setCustomValuesCount = 0
    var configureCount = 0
    var startCount = 0
    var stopCount = 0
    var createPrivacyProfileCount = 0
    var setPrivacyProfileCount = 0
    
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
    var lastCustomIdentifiers: [String: String]?
    var lastCustomValues: [String: Any]?
    var lastConfigureObject: Any?
    var lastSentEvents: [Event] = []
    var lastPrivacyProfileName: String?
    var lastPrivacyDatapoints: [String]?
    var lastPrivacyEnabled: Bool?
    
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
    
    func setSleep(_ sleep: Bool) {
        setSleepCount += 1
        lastSleepTracker = sleep
    }
    
    func invalidate() {
        invalidateCount += 1
    }
    
    func send(event: Event) {
        sendEventCount += 1
        lastSentEvents.append(event)
    }
    
    func setIdentityLinks(with info: [String : String]) {
        setIdentityLinksCount += 1
        lastIdentityLinks = info
    }
    
    func setCustomIdentifiers(with identifiers: [String: String]) {
        setCustomIdentifiersCount += 1
        lastCustomIdentifiers = identifiers
    }
    
    func setCustomValues(with values: [String: Any]) {
        setCustomValuesCount += 1
        lastCustomValues = values
    }
    
    func configure(with object: Any?) {
        configureCount += 1
        lastConfigureObject = object
    }
    
    func start() {
        startCount += 1
    }
    
    func stop() {
        stopCount += 1
    }
    
    func createPrivacyProfile(name: String, datapoints: [String]) {
        createPrivacyProfileCount += 1
        lastPrivacyProfileName = name
        lastPrivacyDatapoints = datapoints
    }
    
    func setPrivacyProfile(name: String, enabled: Bool) {
        setPrivacyProfileCount += 1
        lastPrivacyProfileName = name
        lastPrivacyEnabled = enabled
    }
}