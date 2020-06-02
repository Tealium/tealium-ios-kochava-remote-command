//
//  KochavaRemoteCommand.swift
//  TealiumKochava
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import TealiumIOS

@objc
public class KochavaRemoteCommand: NSObject {

    var tealKochavaTracker: KochavaTrackable

    @objc
    public init(tealKochavaTracker: KochavaTrackable = TealiumKochavaTracker()) {
        self.tealKochavaTracker = tealKochavaTracker
    }

    @objc
    public func remoteCommand() -> TEALRemoteCommandResponseBlock {
        return { response in

            guard var payload = response?.requestPayload as? [String: Any],
                let command = payload[KochavaConstants.commandName] as? String else {
                return
            }
            let commands = command.split(separator: KochavaConstants.separator)
            let kochavaCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            payload = payload.stringsToBools
            self.parseCommands(kochavaCommands, payload: payload)
        }
    }

    func parseCommands(_ commands: [String], payload: [String: Any]) {
        commands.forEach { command in
            let commandName = KochavaConstants.Commands(rawValue: command.lowercased())
            switch commandName {
            case .configure:
                var config = [AnyHashable: Any]()
                guard let appGUID = payload[KochavaConstants.ConfigKey.apiKey] else {
                    print("\(KochavaConstants.errorPrefix)`app_guid` is required to configure Kochava.")
                    return
                }
                config[kKVAParamAppGUIDStringKey] = appGUID

                if let logLevel = payload[.logLevel] as? String {
                    config[kKVAParamLogLevelEnumKey] = logLevel.capitalized
                }

                if let shouldSendDeviceId = payload[.sendDeviceId] as? Bool,
                    shouldSendDeviceId == true,
                    let kochavaDeviceIdString = KochavaTracker.shared.deviceIdString() {
                    tealKochavaTracker.tealium?.addVolatileDataSources([KochavaConstants.ConfigKey.kvaDeviceID.rawValue: kochavaDeviceIdString])
                }

                if let shouldSendSdkVersion = payload[.sendSDKVersion] as? Bool,
                    shouldSendSdkVersion == true,
                    let sdkVersionString = KochavaTracker.shared.sdkVersionString() {
                    tealKochavaTracker.tealium?.addVolatileDataSources([KochavaConstants.ConfigKey.kvaSDKVersion.rawValue: sdkVersionString])
                }

                if let identityLink = payload[.identityLinks] as? [String: String] {
                    config[kKVAParamIdentityLinkDictionaryKey] = identityLink
                }

                if let attribution = payload[.retrieveAttributionData] as? Bool, attribution == true {
                    config[kKVAParamRetrieveAttributionBoolKey] = true
                }

                if let limitAdTracking = payload[.limitAdTracking] as? Bool {
                    config[kKVAParamAppLimitAdTrackingBoolKey] = limitAdTracking
                }

                tealKochavaTracker.configure(with: config)

                if let sleepTracker = payload[.sleepTracker] as? Bool {
                    tealKochavaTracker.sleepTracker(sleepTracker)
                }
            case .sleeptracker:
                guard let sleepTracker = payload[.sleepTracker] as? Bool else {
                    print("\(KochavaConstants.errorPrefix)`sleep_tracker` mapping is required in order to toggle sleep.")
                    return
                }
                tealKochavaTracker.sleepTracker(sleepTracker)
            case .invalidate:
                tealKochavaTracker.invalidate()
            case .sendidentitylink:
                if let identityLink = payload[KochavaConstants.ConfigKey.identityLinks] as? [String: String] {
                    tealKochavaTracker.sendIdentityLink(with: identityLink)
                }
            case .custom:
                guard let eventName = payload[.customEventNameString] as? String else {
                    print("\(KochavaConstants.errorPrefix)`custom_event_name` is required for custom events.")
                    return
                }
                if let infoDictionary = payload[.infoDictionary] as? [String: Any] {
                    return tealKochavaTracker.sendEvent(name: eventName, dictionary: infoDictionary)
                }
                guard let infoString = payload[.infoString] as? String else {
                    return tealKochavaTracker.sendEvent(name: eventName)
                }
                return tealKochavaTracker.sendEvent(name: eventName, string: infoString)
            default:
                if let kochavaEventName = KochavaConstants.Events(rawValue: command.lowercased()) {
                    tealKochavaTracker.sendEvent(type: kochavaEvent[kochavaEventName], dictionary: payload)
                }
                break
            }
        }
    }

    let kochavaEvent = EnumMap<KochavaConstants.Events, KochavaEventTypeEnum> { command in
        switch command {
        case .addtocart:
            return KochavaEventTypeEnum.addToCart
        case .addtowishlist:
            return KochavaEventTypeEnum.addToWishList
        case .achievement:
            return KochavaEventTypeEnum.achievement
        case .levelcomplete:
            return KochavaEventTypeEnum.levelComplete
        case .purchase:
            return KochavaEventTypeEnum.purchase
        case .checkoutstart:
            return KochavaEventTypeEnum.checkoutStart
        case .rating:
            return KochavaEventTypeEnum.rating
        case .search:
            return KochavaEventTypeEnum.search
        case .tutorialcomplete:
            return KochavaEventTypeEnum.tutorialComplete
        case .view:
            return KochavaEventTypeEnum.view
        case .adview:
            return KochavaEventTypeEnum.adView
        case .adclick:
            return KochavaEventTypeEnum.adClick
        case .pushrecieved:
            return KochavaEventTypeEnum.pushReceived
        case .pushopened:
            return KochavaEventTypeEnum.pushOpened
        case .consentgranted:
            return KochavaEventTypeEnum.consentGranted
        case .subscribe:
            return KochavaEventTypeEnum.subscribe
        case .registrationcomplete:
            return KochavaEventTypeEnum.registrationComplete
        case .starttrial:
            return KochavaEventTypeEnum.startTrial
        }
    }
    
    

}

fileprivate extension Dictionary where Key == String, Value == Any {
    var stringsToBools: [String: Any] {
        self.reduce(into: [String: Any]()) { result, dictionary in
            guard let value = dictionary.value as? String,
                value == "true" || value == "false" else {
                    result[dictionary.key] = dictionary.value
                    return
            }
            let boolValue = Bool(value)
            result[dictionary.key] = boolValue
        }
    }
}

fileprivate extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(key: KochavaConstants.ConfigKey) -> Value? {
        get {
            return self[key.rawValue as! Key]
        }
        set {
            self[key.rawValue as! Key] = newValue
        }
    }
    subscript(key: KochavaConstants.EventKeys) -> Value? {
        get {
            return self[key.rawValue as! Key]
        }
        set {
            self[key.rawValue as! Key] = newValue
        }
    }
}
