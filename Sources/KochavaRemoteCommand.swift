//
//  KochavaRemoteCommand.swift
//  TealiumKochava
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumRemoteCommands
    import TealiumVolatileData
#endif

public class KochavaRemoteCommand {

    var tealKochavaTracker: KochavaTrackable?

    public init(tealKochavaTracker: KochavaTrackable = TealiumKochavaTracker()) {
        self.tealKochavaTracker = tealKochavaTracker
    }

    public func remoteCommand() -> TealiumRemoteCommand {
        return TealiumRemoteCommand(commandId: "kochava", description: "Kochava Remote Command") { response in

            let payload = response.payload()
            guard let command = payload[KochavaConstants.commandName] as? String else {
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

        let kochavaEventData = eventData(with: payload)

        kochavaCommands.forEach { command in
            let lowercasedCommand = command.lowercased()
            switch lowercasedCommand {
            case KochavaConstants.Commands.configure:
                var config = [AnyHashable: Any]()
                guard let appGUID = payload[KochavaConstants.ConfigKey.apiKey] else {
                    print("\(KochavaConstants.errorPrefix)`app_guid` is required to configure Kochava.")
                    return
                }
                config[kKVAParamAppGUIDStringKey] = appGUID

                if let logLevel = payload[KochavaConstants.ConfigKey.logLevel] as? String {
                    config[kKVAParamLogLevelEnumKey] = logLevel.capitalized
                }

                if let shouldSendDeviceId = payload[KochavaConstants.ConfigKey.sendDeviceId] as? Bool,
                    shouldSendDeviceId == true,
                    let kochavaDeviceIdString = KochavaTracker.shared.deviceIdString() {
                    tealKochavaTracker.tealium?.volatileData()?.add(data: [KochavaConstants.ConfigKey.kvaDeviceID: kochavaDeviceIdString])
                }

                if let shouldSendSdkVersion = payload[KochavaConstants.ConfigKey.sendSDKVersion] as? Bool,
                    shouldSendSdkVersion == true,
                    let sdkVersionString = KochavaTracker.shared.sdkVersionString() {
                    tealKochavaTracker.tealium?.volatileData()?.add(data: [KochavaConstants.ConfigKey.kvaSDKVersion: sdkVersionString])
                }

                if let identityLink = payload[KochavaConstants.ConfigKey.identityLinks] as? [String: String] {
                    config[kKVAParamIdentityLinkDictionaryKey] = identityLink
                }

                if let attribution = payload[KochavaConstants.ConfigKey.retrieveAttributionData] as? Bool, attribution == true {
                    config[kKVAParamRetrieveAttributionBoolKey] = true
                }

                if let limitAdTracking = payload[KochavaConstants.ConfigKey.limitAdTracking] as? Bool {
                    config[kKVAParamAppLimitAdTrackingBoolKey] = limitAdTracking
                }

                tealKochavaTracker.configure(with: config)

                if let sleepTracker = payload[KochavaConstants.ConfigKey.sleepTracker] as? Bool {
                    tealKochavaTracker.sleepTracker(sleepTracker)
                }
            case KochavaConstants.Commands.sleeptracker:
                guard let sleepTracker = payload[KochavaConstants.ConfigKey.sleepTracker] as? Bool else {
                    print("\(KochavaConstants.errorPrefix)`sleep_tracker` mapping is required in order to toggle sleep.")
                    return
                }
                tealKochavaTracker.sleepTracker(sleepTracker)
            case KochavaConstants.Commands.invalidate:
                tealKochavaTracker.invalidate()
            case KochavaConstants.Commands.sendidentitylink:
                if let identityLink = payload[KochavaConstants.ConfigKey.identityLinks] as? [String: String] {
                    tealKochavaTracker.sendIdentityLink(with: identityLink)
                }
            case KochavaConstants.Commands.custom:
                guard let eventName = kochavaEventData?.customEventNameString else {
                    print("\(KochavaConstants.errorPrefix)`custom_event_name` is required for custom events.")
                    return
                }
                if let infoDictionary = kochavaEventData?.infoDictionary {
                    return tealKochavaTracker.sendEvent(name: eventName, with: infoDictionary)
                }
                guard let infoString = kochavaEventData?.infoString else {
                    return tealKochavaTracker.sendEvent(name: eventName)
                }
                return tealKochavaTracker.sendEvent(name: eventName, with: infoString)
            default:
                if let kochavaEventName = KochavaConstants.Events(rawValue: lowercasedCommand) {
                    tealKochavaTracker.sendEvent(type: kochavaEvent[kochavaEventName], with: kochavaEventData)
                }
                break
            }
        }
    }

    func eventData(with payload: [String: Any]) -> KochavaEventKeys? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload),
            let decoded = try? JSONDecoder().decode(KochavaEventKeys.self, from: jsonData) else {
                print("\(KochavaConstants.errorPrefix) could not encode/decode payload.")
                return nil
        }
        return decoded
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

