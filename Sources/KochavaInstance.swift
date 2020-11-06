//
//  KochavaInstance.swift
//  TealiumKochava
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import UIKit
import KochavaTracker
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif

public protocol KochavaEventProtocol: class { }
extension KVAEvent: KochavaEventProtocol { }

public protocol KochavaCommand {
    var attEnabled: Bool { get set }
    var limitAdTracking: Bool { get set }
    var logLevel: String { get set }
    func initialize(with payload: [String: Any], appGuid: String)
    func start(with appGuid: String)
    func sleepTracker(_ sleep: Bool)
    func invalidate()
    func sendCustom(event name: String)
    func sendCustom(event name: String, with dictionary: [String: Any])
    func send(event: KVAEvent)
    func send(event: KVAEvent, with dictionary: [String : Any])
    func sendIdentityLink(with info: [String: String])
    func retrieveProperties<T: KochavaEventProtocol>(from cls: T.Type) -> [String]
}

public class KochavaInstance: KochavaCommand, TealiumRegistration, TealiumDeepLinkable {
    public init() { }
    
    public var attEnabled: Bool {
        get {
            KVATracker.shared.appTrackingTransparency.enabledBool
        }
        set {
            KVATracker.shared.appTrackingTransparency.enabledBool = newValue
        }
    }
    
    public var limitAdTracking: Bool {
        get {
            KVATracker.shared.appLimitAdTrackingBool
        }
        set {
            KVATracker.shared.appLimitAdTrackingBool = newValue
        }
    }
    
    public var logLevel: String {
        get {
            KVALog.shared.level.nameString
        }
        set {
            KVALog.shared.level = KVALogLevel.from(string: newValue)
        }
    }
    
    public func initialize(with payload: [String: Any], appGuid: String) {
        if let appLimitAdTracking = payload[KochavaConstants.Keys.limitAdTracking] as? Int {
            limitAdTracking = appLimitAdTracking.toBool
        } else if let appLimitAdTracking = payload[KochavaConstants.Keys.limitAdTracking] as? Bool {
            limitAdTracking = appLimitAdTracking
        }
        start(with: appGuid)
        if let identityLink = payload[KochavaConstants.Keys.identityLinks] as? [String: String] {
            sendIdentityLink(with: identityLink)
        }
        if let sleep = payload[KochavaConstants.Keys.sleepTracker] as? Int {
            sleepTracker(sleep.toBool)
        } else if let sleep = payload[KochavaConstants.Keys.sleepTracker] as? Bool {
            sleepTracker(sleep)
        }
    }
    
    public func start(with appGuid: String) {
        KVATracker.shared.start(withAppGUIDString: appGuid)
    }
    
    public func sleepTracker(_ sleep: Bool) {
        KVATracker.shared.sleepBool = sleep
    }
    
    public func invalidate() {
        KVATracker.shared.invalidate()
    }
    
    public func sendCustom(event name: String) {
        KVAEvent.sendCustom(withNameString: name)
    }
    
    public func sendCustom(event name: String, with dictionary: [String: Any]) {
        KVAEvent.sendCustom(withNameString: name, infoDictionary: dictionary)
    }
    
    public func send(event: KVAEvent) {
        event.send()
    }
    
    public func send(event: KVAEvent, with dictionary: [String : Any]) {
        let properties = retrieveProperties(from: KVAEvent.self)
        KochavaConstants.eventParameters.map(dictionary)
             .filter { properties.contains($0.key) }
             .forEach {
                event.setValue($0.value, forKey: $0.key)
             }
        event.send()
    }
    
    public func sendIdentityLink(with info: [String: String]) {
        info.forEach {
            KVATracker.shared.identityLink.register(withNameString: $0.key, identifierString: $0.value)
        }
    }
    
    // MARK: Push Notification Tracking
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-push-notification/
    public func registerPushToken(_ token: String) {
        guard let kvaToken = KVAPushNotificationsToken.kva_fromObject(token) else {
            return
        }
        KVATracker.shared.pushNotifications.addToken(kvaToken)
    }
    
    public func application(_ application: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                            fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // .... Optional tracking, implement a custom event here.
        // Example:
        // sendCustom(event: "Push Message Opened", with: userInfo)
    }
    
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let event = KVAEvent(type: .pushOpened)
        event.payloadDictionary = response.notification.request.content.userInfo
        event.actionString = response.actionIdentifier
        event.send()
    }
    
    // MARK: Enhanced Deeplinking - Example
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-using-the-sdk/#collapseEnhancedDeeplinking
    public func application(_ application: UIApplication,
                            continue userActivity: NSUserActivity,
                            restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let url = userActivity.webpageURL
        KVADeeplink.process(withURL: url) { deeplink in
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
    
}

fileprivate extension Dictionary where Key == String, Value == String {
    func map(_ eventParameters: [String: Any]) -> [String: Any] {
        self.reduce(into: [String: Any]()) { result, dictionary in
            if eventParameters[dictionary.key] != nil {
                result[dictionary.value] = eventParameters[dictionary.key]
            }
        }
    }
}

extension KochavaInstance {
    public func retrieveProperties<T: KochavaEventProtocol>(from cls: T.Type) -> [String] {
        var count = UInt32()
        var propertyNames = [String]()
        guard let properties : UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(cls, &count) else {
            return []
        }
        for i in 0..<Int(count) {
            let property : objc_property_t = properties[i]
            guard let propertyName = NSString(utf8String: property_getName(property)) as String? else {
                print("\(KochavaConstants.errorPrefix)Couldn't unwrap property name for \(property)")
                break
            }
            propertyNames.append(propertyName)
        }
        return propertyNames
    }
}


