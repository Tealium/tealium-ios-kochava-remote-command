//
//  KochavaInstance.swift
//  TealiumKochava
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import UserNotifications
#if canImport(UIKit)
import UIKit
#endif
// Kochava v8 imports - split from KochavaTracker
import KochavaNetworking
import KochavaMeasurement
import KochavaTracking
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public protocol KochavaCommand {
    func setAppTrackingTransparency(enabled: Bool, waitTime: TimeInterval?, autoRequest: Bool?)
    func setLimitAdTracking(_ limitAdTracking: Bool)
    func setLogLevel(_ level: Log.Level)
    func onReady(_ onReady: @escaping () -> Void)
    func initialize(appGuid: String)
    func setSleep(_ sleep: Bool)
    func invalidate()
    func send(event: Event)
    func setIdentityLinks(with info: [String: String])
    func setCustomIdentifiers(with identifiers: [String: String])
    func setCustomValues(with values: [String: Any])
    func configure(with object: Any?)
    func start()
    func stop()
    func createPrivacyProfile(name: String, datapoints: [String])
    func setPrivacyProfile(name: String, enabled: Bool)
}

public class KochavaInstance: KochavaCommand { 
    
    public init() { }
    
    private var _onReady = TealiumReplaySubject<Void>(cacheSize: 1)
    
    public func onReady(_ onReady: @escaping () -> Void) {
        TealiumQueues.secureMainThreadExecution {
            self._onReady.subscribeOnce(onReady)
        }
    }
            
    public func initialize(appGuid: String) {
 
        Measurement.shared.start(appGUIDString: appGuid)
        
        // Optional: Start tracking for IDFA collection
        Tracking.shared.start()
        
        // Notify that Kochava is ready
        _onReady.publish()
    }

    public func setAppTrackingTransparency(enabled: Bool, waitTime: TimeInterval? = nil, autoRequest: Bool? = nil) {
        let measurement = Measurement.shared
        
        // Enable/disable ATT enforcement
        measurement.appTrackingTransparency.enabledBool = enabled
        
        // Optional: Set custom wait time (default: 30 seconds)
        if let waitTime = waitTime {
            measurement.appTrackingTransparency.authorizationStatusWaitTimeInterval = waitTime
        }
        
        // Optional: Set auto-request behavior (default: true)
        if let autoRequest = autoRequest {
            measurement.appTrackingTransparency.autoRequestTrackingAuthorizationBool = autoRequest
        }
    }
    
    public func setLimitAdTracking(_ limitAdTracking: Bool) {
        Measurement.shared.appLimitAdTracking.bool = limitAdTracking
    }
    
    public func setLogLevel(_ level: Log.Level) {
        Log.shared.level = level
    }
    
    public func setSleep(_ sleep: Bool) {
        Measurement.shared.sleepBool = sleep
    }
    
    public func invalidate() {
        Measurement.shared.invalidate()
    }
    
    public func send(event: Event) {
        event.send()
    }
    
    public func setIdentityLinks(with info: [String: String]) {
        info.forEach { key, value in
            IdentityLink.register(name: key, identifier: value)
        }
    }
    
    public func setCustomIdentifiers(with identifiers: [String: String]) {
        identifiers.forEach { name, identifier in
            CustomIdentifier.register(name: name, identifier: identifier)
        }
    }
    
    public func setCustomValues(with values: [String: Any]) {
        values.forEach { name, value in
            CustomValue.register(name: name, value: value)
        }
    }
    
    public func configure(with object: Any?) {
        Measurement.shared.configure(with: object, context: .host)
    }
    
    public func start() {
        Measurement.shared.start()
    }
    
    public func stop() {
        Measurement.shared.stop()
    }
    
    public func createPrivacyProfile(name: String, datapoints: [String]) {
        PrivacyProfile.register(name: name, datapointKeyArray: datapoints)
    }
    
    public func setPrivacyProfile(name: String, enabled: Bool) {
        Measurement.shared.privacy.setEnabledBool(forProfileName: name, enabledBool: enabled)
    }
}
