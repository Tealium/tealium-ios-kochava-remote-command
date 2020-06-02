//
//  TealiumKochavaTracker.swift
//  json-rc-test
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Schelly. All rights reserved.
//

import UIKit
import TealiumIOS

public protocol KochavaEventProtocol: class { }
extension KochavaEvent: KochavaEventProtocol { }

@objc
public protocol KochavaTrackable {
    var tealium: Tealium? { get set }
    func configure(with parameters: [AnyHashable: Any])
    func sleepTracker(_ sleep: Bool)
    func invalidate()
    func sendEvent(name: String)
    func sendEvent(name: String, string: String?)
    func sendEvent(name: String, dictionary: [String: Any]?)
    func sendEvent(type: KochavaEventTypeEnum, dictionary: [String: Any]?)
    func sendIdentityLink(with info: [AnyHashable: Any])
    func retrieveProperties() -> [String]
    func eventData(with payload: [String: Any]) -> KochavaEventKeys?
}

@objc
public class TealiumKochavaTracker: NSObject, KochavaTrackable, TealiumRegistration, TealiumDeepLinkable {

    weak public var tealium: Tealium?

    public override init() { }

    public init(tealium: Tealium) {
        self.tealium = tealium
    }

    public func configure(with parameters: [AnyHashable: Any]) {
        if let attribution = parameters[kKVAParamRetrieveAttributionBoolKey] as? Bool, attribution == true {
            KochavaTracker.shared.configure(withParametersDictionary: parameters, delegate: self)
        } else {
            KochavaTracker.shared.configure(withParametersDictionary: parameters, delegate: nil)
        }
        if let sleep = parameters[KochavaConstants.ConfigKey.sleepTracker] as? Bool,
            sleep == true {
            sleepTracker(sleep)
        }
    }

    public func sleepTracker(_ sleep: Bool) {
        KochavaTracker.shared.sleepBool = sleep
    }

    public func invalidate() {
        KochavaTracker.shared.invalidate()
    }

    public func sendEvent(type: KochavaEventTypeEnum, dictionary: [String: Any]?) {
        if let event = KochavaEvent(eventTypeEnum: type) {
            if let dictionary = dictionary, let eventKeys = eventData(with: dictionary) {
                let properties = retrieveProperties()
                KochavaEventKeys.lookup.mapPayload(eventKeys.dictionary ?? [:])
                    .filter { properties.contains($0.key) }
                    .forEach { event.setValue($0.value, forKey: $0.key) }
                KochavaTracker.shared.send(event)
            }
        }
    }

    public func sendEvent(name: String) {
        KochavaTracker.shared.sendEvent(withNameString: name, infoString: nil)
    }

    public func sendEvent(name: String, string: String?) {
        KochavaTracker.shared.sendEvent(withNameString: name, infoString: string)
    }

    public func sendEvent(name: String, dictionary: [String: Any]?) {
        KochavaTracker.shared.sendEvent(withNameString: name, infoDictionary: dictionary)
    }

    public func sendIdentityLink(with info: [AnyHashable: Any]) {
        KochavaTracker.shared.sendIdentityLink(with: info)
    }

    // MARK: Push Notification Tracking
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-push-notification/

    public func registerPushToken(_ token: String) {
        guard let deviceToken = Data(base64Encoded: token, options: .ignoreUnknownCharacters) else {
            print("Tealium Kochava: Error converting device token.")
            return
        }
        KochavaTracker.shared.addRemoteNotificationsDeviceToken(deviceToken)
    }

    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        /// .... Optional tracking, implement a custom event here.
        /// Example:
        /// tealium?.track(title: "push_message_opened", data: userInfo as? [String: Any], completion: nil)
        /// Or
        /// KochavaTracker.shared.sendEvent(withNameString: "Push Message Opened", infoDictionary: userInfo)
    }

    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if let event = KochavaEvent(eventTypeEnum: .pushOpened)
        {
            event.payloadDictionary = response.notification.request.content.userInfo
            event.actionString = response.actionIdentifier
            KochavaTracker.shared.send(event)
        }
    }

    // MARK: Enhanced Deeplinking - Example
    // https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-using-the-sdk/#collapseEnhancedDeeplinking
    public func application(_ application: TealiumApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let url = userActivity.webpageURL
        KVADeeplink.process(withURL: url) { deeplink in
            if let destination = deeplink.destinationString,
                destination.count > 0 {
                // deeplink exists, parse the destination as you see fit
                let components = URLComponents(string: destination)
                // route the user to the destination accordingly
                print(components ?? "")
            } else {
                // no deeplink to act upon, route to a default destination or take no action
            }
        }
        return true
    }

}

// MARK: KochavaTrackerDelegate
extension TealiumKochavaTracker: KochavaTrackerDelegate {
    public func tracker(_ tracker: KochavaTracker,
        didRetrieveAttributionDictionary attributionDictionary: [AnyHashable: Any]) {
        guard let attributionDictionary = attributionDictionary as? [String: Any] else {
            return
        }
        tealium?.addVolatileDataSources(attributionDictionary)
        tealium?.trackEvent(withTitle: "attribution", dataSources: attributionDictionary)
    }
}

// MARK: Helper Methods
extension TealiumKochavaTracker {
    public func retrieveProperties() -> [String] {
        var count = UInt32()
        var propertyNames = [String]()

        guard let properties: UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(KochavaEvent.self, &count) else {
            return []
        }

        for i in 0..<Int(count) {
            let property: objc_property_t = properties[i]
            guard let propertyName = NSString(utf8String: property_getName(property)) as String? else {
                print("Tealium Kochava: Couldn't unwrap property name for \(property)")
                break
            }

            propertyNames.append(propertyName)
        }
        return propertyNames
    }

    public func eventData(with payload: [String: Any]) -> KochavaEventKeys? {
        KochavaEventKeys.create(from: payload)
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: payload)
//            let decoded = try JSONDecoder().decode(KochavaEventKeys.self, from: jsonData)
//            return decoded
//        } catch {
//            print("\(KochavaConstants.errorPrefix)\(error)")
//        }
//        return nil
    }
}

extension Dictionary where Key == String, Value == String {
    public func mapPayload(_ payload: [String: Any]) -> [String: Any] {
        return self.reduce(into: [String: Any]()) { result, dictionary in
            if payload[dictionary.key] != nil {
                result[dictionary.value] = payload[dictionary.key]
            }
        }
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
