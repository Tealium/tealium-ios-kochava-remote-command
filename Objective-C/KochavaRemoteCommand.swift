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
    var loggingEnabled = false

    @objc
    public init(tealKochavaTracker: KochavaTrackable = TealiumKochavaTracker()) {
        self.tealKochavaTracker = tealKochavaTracker
    }

    @objc
    public func remoteCommand() -> TEALRemoteCommandResponseBlock {
        return { response in
            guard let payload = response?.requestPayload as? [String: Any],
                let command = payload[KochavaConstants.commandName] as? String else {
                return
            }
            let commands = command.split(separator: KochavaConstants.separator)
            let kochavaCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
            self.parseCommands(kochavaCommands, payload: payload)
        }
    }

    func parseCommands(_ commands: [String], payload: [String: Any]) {
        commands.forEach { command in
            let commandName = KochavaConstants.Commands(rawValue: command.lowercased())
            switch commandName {
            case .configure:
                var config = [AnyHashable: Any]()
                if let logLevel = payload[.logLevel] as? String {
                    if logLevel == "debug" || logLevel == "warn" {
                        loggingEnabled = true
                    }
                    config[kKVAParamLogLevelEnumKey] = logLevel.capitalized
                }
                guard let appGUID = payload[.apiKey] else {
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`app_guid` is required to configure Kochava.")
                    }
                    return
                }
                config[kKVAParamAppGUIDStringKey] = appGUID
                if let shouldSendDeviceId = payload[.sendDeviceId] as? Bool,
                    shouldSendDeviceId == true,
                    let kochavaDeviceIdString = KochavaTracker.shared.deviceIdString() {
                    let deviceId = [KochavaConstants.Keys.kvaDeviceID.rawValue: kochavaDeviceIdString]
                    tealKochavaTracker.tealium?.addVolatileDataSources(deviceId)
                }
                if let shouldSendSdkVersion = payload[.sendSDKVersion] as? Bool,
                    shouldSendSdkVersion == true,
                    let sdkVersionString = KochavaTracker.shared.sdkVersionString() {
                    let sdkVersion = [KochavaConstants.Keys.kvaSDKVersion.rawValue: sdkVersionString]
                    tealKochavaTracker.tealium?.addVolatileDataSources(sdkVersion)
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
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`sleep_tracker` mapping is required in order to toggle sleep.")
                    }
                    return
                }
                tealKochavaTracker.sleepTracker(sleepTracker)
            case .invalidate:
                tealKochavaTracker.invalidate()
            case .sendidentitylink:
                if let identityLink = payload[.identityLinks] as? [String: String] {
                    tealKochavaTracker.sendIdentityLink(with: identityLink)
                }
            case .custom:
                guard let eventName = payload[.customEventNameString] as? String else {
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`custom_event_name` is required for custom events.")
                    }
                    return
                }
                guard let eventPayload = payload[.eventPayload] as? [String: Any],
                    let infoDictionary = eventPayload[.infoDictionary] as? [String: Any] else {
                    tealKochavaTracker.sendEvent(name: eventName)
                    return
                }
                tealKochavaTracker.sendEvent(name: eventName, with: infoDictionary)
                return
            default:
                if let event = KochavaConstants.Events(rawValue: command.lowercased()) {
                    guard let eventPayload = payload[.eventPayload] as? [String: Any] else {
                        tealKochavaTracker.sendEvent(type: KochavaEventTypeEnum(event))
                        return
                    }
                    tealKochavaTracker.sendEvent(type: KochavaEventTypeEnum(event), with: eventPayload)
                }
                break
            }
        }
    }

}

fileprivate extension Dictionary where Key: ExpressibleByStringLiteral {
    subscript(key: KochavaConstants.Keys) -> Value? {
        get {
            return self[key.rawValue as! Key]
        }
        set {
            self[key.rawValue as! Key] = newValue
        }
    }
}

extension KochavaEventTypeEnum {
    init(_ eventType: KochavaConstants.Events) {
        switch eventType {
        case .addtocart:
            self = KochavaEventTypeEnum.addToCart
        case .addtowishlist:
            self = KochavaEventTypeEnum.addToWishList
        case .achievement:
            self = KochavaEventTypeEnum.achievement
        case .levelcomplete:
            self = KochavaEventTypeEnum.levelComplete
        case .purchase:
            self = KochavaEventTypeEnum.purchase
        case .checkoutstart:
            self = KochavaEventTypeEnum.checkoutStart
        case .rating:
            self = KochavaEventTypeEnum.rating
        case .search:
            self = KochavaEventTypeEnum.search
        case .tutorialcomplete:
            self = KochavaEventTypeEnum.tutorialComplete
        case .view:
            self = KochavaEventTypeEnum.view
        case .adview:
            self = KochavaEventTypeEnum.adView
        case .adclick:
            self = KochavaEventTypeEnum.adClick
        case .pushrecieved:
            self = KochavaEventTypeEnum.pushReceived
        case .pushopened:
            self = KochavaEventTypeEnum.pushOpened
        case .consentgranted:
            self = KochavaEventTypeEnum.consentGranted
        case .subscribe:
            self = KochavaEventTypeEnum.subscribe
        case .registrationcomplete:
            self = KochavaEventTypeEnum.registrationComplete
        case .starttrial:
            self = KochavaEventTypeEnum.startTrial
        }
    }
}
