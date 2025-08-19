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
    func sleepTracker(_ sleep: Bool)
    func invalidate()
    func send(event: Event)
    func sendIdentityLink(with info: [String: String])
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
    
    public func sleepTracker(_ sleep: Bool) {
        Measurement.shared.sleepBool = sleep
    }
    
    public func invalidate() {
        Measurement.shared.invalidate()
    }
    
    public func send(event: Event) {
        event.send()
    }
    

    
    public func sendIdentityLink(with info: [String: String]) {
        info.forEach { key, value in
            IdentityLink.register(name: key, identifier: value)
        }
    }
    
    // MARK: Push Notification Tracking
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-push-notification/
    public func registerPushToken(_ token: String) {
        // v8 API: Push token registration - API may have changed
        // TODO: Update this to correct v8 API when available
        print("KochavaInstance: Push token registration - \(token)")
        // Placeholder implementation - needs actual v8 API
    }
    
    #if os(iOS)
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // .... Optional tracking, implement a custom event here.
        // Example:
        // sendCustom(event: "Push Message Opened", with: userInfo)
    }
    #endif
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let event = Event(type: .pushOpened)
        event.payloadDictionary = response.notification.request.content.userInfo
        event.actionString = response.actionIdentifier
        event.send()
    }
    
    // MARK: Enhanced Deeplinking - Example
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-using-the-sdk/#collapseEnhancedDeeplinking
    #if os(iOS)
    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let url = userActivity.webpageURL
        // v8 API: Deeplink processing (removed KVA prefix)
        Deeplink.process(url: url) { deeplink in
            guard let destination = deeplink.destinationString,
                destination.count > 0 else {
                // no deeplink
                return
            }
            // deeplink exists, parse the destination as you see fit
            // let components = URLComponents(string: destination)
            // route the user to the destination accordingly
            // print(components ?? "")
        }
        return true
    }
    #endif
    
}



