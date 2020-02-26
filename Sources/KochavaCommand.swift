//
//  KochavaCommand.swift
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

public class KochavaCommand {

    var tealKochavaTracker: KochavaTrackable?

    public init(tealKochavaTracker: KochavaTrackable = TealiumKochavaTracker()) {
        self.tealKochavaTracker = tealKochavaTracker
    }

    public func remoteCommand() -> TealiumRemoteCommand {
        return TealiumRemoteCommand(commandId: "kochava", description: "Kochava Remote Command") { response in

            let payload = response.payload()
            guard let command = payload[Kochava.commandName] as? String else {
                return
            }
            let commands = command.split(separator: ",")
            let firebaseCommands = commands.map { command in
                return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
             self.parseCommands(firebaseCommands, payload: payload)
        }
    }

   func parseCommands(_ commands: [String], payload: [String: Any]) {
        guard let tealKochavaTracker = tealKochavaTracker,
            let command = payload[Kochava.ConfigKey.command] as? String else {
                return
        }

        let commands = command.split(separator: ",")
        let kochavaCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }

        kochavaCommands.forEach { command in
            let lowercasedCommand = command.lowercased()
            if let kochavaEventName = Kochava.Events(rawValue: lowercasedCommand) {
                tealKochavaTracker.sendEvent(type: kochavaEvent[kochavaEventName], with: payload)
            } else {
                switch lowercasedCommand {
                case Kochava.Commands.configure:
                    var config = [AnyHashable: Any]()
                    guard let appGUID = payload[Kochava.ConfigKey.apiKey] else {
                        print("Tealium Kochava: An App GUID is required to configure Kochava.")
                        return
                    }
                    config[kKVAParamAppGUIDStringKey] = appGUID
                    
                    if let logLevel = payload[Kochava.ConfigKey.logLevel] as? String {
                        config[kKVAParamLogLevelEnumKey] = logLevel.capitalized
                    }
                    
                    if let shouldSendDeviceId = payload[Kochava.ConfigKey.sendDeviceId] as? Bool,
                        shouldSendDeviceId == true,
                        let kochavaDeviceIdString = KochavaTracker.shared.deviceIdString() {
                        tealKochavaTracker.tealium?.volatileData()?.add(data: [Kochava.ConfigKey.kvaDeviceID: kochavaDeviceIdString])
                    }
                    
                    if let shouldSendSdkVersion = payload[Kochava.ConfigKey.sendSDKVersion] as? Bool,
                        shouldSendSdkVersion == true,
                        let sdkVersionString = KochavaTracker.shared.sdkVersionString() {
                        tealKochavaTracker.tealium?.volatileData()?.add(data: [Kochava.ConfigKey.kvaSDKVersion: sdkVersionString])
                    }
                    
                    if let identityLink = payload[Kochava.ConfigKey.identityLinks] as? [String: String] {
                        config[kKVAParamIdentityLinkDictionaryKey] = identityLink
                    }
                    
                    if let attribution = payload[Kochava.ConfigKey.retrieveAttributionData] as? Bool, attribution == true {
                        config[kKVAParamRetrieveAttributionBoolKey] = true
                    }
                    
                    if let limitAdTracking = payload[Kochava.ConfigKey.limitAdTracking] as? Bool {
                        config[kKVAParamAppLimitAdTrackingBoolKey] = limitAdTracking
                    }
                    
                    tealKochavaTracker.configure(with: config)
                    
                    if let _ = payload[Kochava.ConfigKey.sleepTracker] as? Bool {
                        tealKochavaTracker.sleepTracker()
                    }
                case Kochava.Commands.sleeptracker:
                    tealKochavaTracker.sleepTracker()
                case Kochava.Commands.invalidate:
                    tealKochavaTracker.invalidate()
                case Kochava.Commands.sendidentitylink:
                    if let identityLink = payload[Kochava.ConfigKey.identityLinks] as? [String: String] {
                        tealKochavaTracker.sendIdentityLink(with: identityLink)
                    }
                case Kochava.Commands.custom:
                    guard let eventName = payload[Kochava.EventKeys.customEventNameString] as? String else {
                        print("Tealium Kochava: `customEventNameString` is required for custom events.")
                        return
                    }
                    if let infoDictionary = payload[Kochava.EventKeys.infoDictionary] as? [String: Any] {
                        return tealKochavaTracker.sendEvent(name: eventName, with: infoDictionary)
                    }
                    guard let infoString = payload[Kochava.EventKeys.infoString] as? String else {
                        return tealKochavaTracker.sendEvent(name: eventName)
                    }
                    return tealKochavaTracker.sendEvent(name: eventName, with: infoString)
                default:
                    break
                }
            }
        }
    }
    
    let kochavaEvent = EnumMap<Kochava.Events, KochavaEventTypeEnum> { command in
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

