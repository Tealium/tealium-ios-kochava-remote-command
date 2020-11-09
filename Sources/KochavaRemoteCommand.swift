//
//  KochavaRemoteCommand.swift
//  TealiumKochava
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import KochavaTracker
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumRemoteCommands
#endif


public class KochavaRemoteCommand: RemoteCommand {

    var kochavaInstance: KochavaCommand?
    var loggingEnabled = false

    public init(kochavaInstance: KochavaCommand = KochavaInstance(), type: RemoteCommandType = .webview) {
        self.kochavaInstance = kochavaInstance
        weak var weakSelf: KochavaRemoteCommand?
        super.init(commandId: KochavaConstants.commandId,
                   description: KochavaConstants.description,
            type: type,
            completion: { response in
                guard let payload = response.payload else {
                    return
                }
                weakSelf?.processRemoteCommand(with: payload)
            })
        weakSelf = self
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard var kochavaInstance = kochavaInstance,
            let command = payload[KochavaConstants.commandName] as? String else {
                return
        }
        let commands = command.split(separator: KochavaConstants.separator)
        let kochavaCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        kochavaCommands.forEach {
            let command = KochavaConstants.Commands(rawValue: $0.lowercased())
            switch command {
            case .initialize:
                if let logLevel = payload[KochavaConstants.Keys.logLevel] as? String {
                    if logLevel == "debug" || logLevel == "warn" {
                        loggingEnabled = true
                    }
                    kochavaInstance.logLevel = logLevel
                }
                guard let appGuid = payload[KochavaConstants.Keys.appGuid] as? String else {
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`app_guid` is required to configure Kochava.")
                    }
                    return
                }
                if let attEnabled = payload[KochavaConstants.Keys.attEnabled] as? Int {
                    kochavaInstance.attEnabled = attEnabled.toBool
                } else if let attEnabled = payload[KochavaConstants.Keys.attEnabled] as? Bool {
                    kochavaInstance.attEnabled = attEnabled
                }
                kochavaInstance.initialize(with: payload, appGuid: appGuid)
            case .sleeptracker:
                guard let sleepTracker = payload[KochavaConstants.Keys.sleepTracker] as? Bool else {
                    if let sleepTracker = payload[KochavaConstants.Keys.sleepTracker] as? Int {
                        return kochavaInstance.sleepTracker(sleepTracker.toBool)
                    }
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`sleep_tracker` mapping is required in order to toggle sleep.")
                    }
                    return
                }
                kochavaInstance.sleepTracker(sleepTracker)
            case .invalidate:
                kochavaInstance.invalidate()
            case .sendidentitylink:
                if let identityLink = payload[KochavaConstants.Keys.identityLinks] as? [String: String] {
                    kochavaInstance.sendIdentityLink(with: identityLink)
                }
            case .custom:
                guard let eventName = payload[KochavaConstants.Keys.customEventNameString] as? String else {
                    if loggingEnabled {
                        print("\(KochavaConstants.errorPrefix)`custom_event_name` is required for custom events.")
                    }
                    return
                }
                // TiQ
                if let eventPayload = payload[KochavaConstants.Keys.eventPayload] as? [String: Any] {
                    kochavaInstance.sendCustom(event: eventName, with: eventPayload)
                    return
                // JSON
                } else if let customParameters = payload[KochavaConstants.Keys.custom] as? [String: Any] {
                    kochavaInstance.sendCustom(event: eventName, with: customParameters)
                    return
                }
                kochavaInstance.sendCustom(event: eventName)
                return
            default:
                if let event = KochavaConstants.Events(rawValue: $0.lowercased()) {
                    // TIQ
                    if let eventPayload = payload[KochavaConstants.Keys.eventPayload] as? [String: Any] {
                        kochavaInstance.send(event: KVAEvent.create(with: event), with: eventPayload)
                        return
                    // JSON
                    } else if var eventPayload = payload[KochavaConstants.Keys.event] as? [String: Any] {
                        if let customParameters = payload[KochavaConstants.Keys.custom] as? [String: Any] {
                            eventPayload[KochavaConstants.Keys.infoDictionary] = customParameters
                        }
                        kochavaInstance.send(event: KVAEvent.create(with: event), with: eventPayload)
                        return
                    } else if var customParameters = payload[KochavaConstants.Keys.custom] as? [String: Any] {
                        customParameters[KochavaConstants.Keys.infoDictionary] = customParameters
                        kochavaInstance.send(event: KVAEvent.create(with: event), with: customParameters)
                    }
                    kochavaInstance.send(event: KVAEvent.create(with: event))
                }
                break
            }
        }
    }

}

extension Int {
    var toBool: Bool {
        self == 0 ? false : true
    }
}


extension KVALogLevel {
    static func from(string: String) -> KVALogLevel {
        switch string {
        case "never":
            return .never
        case "error":
            return .error
        case "warn":
            return .warn
        case "info":
            return .info
        case "debug":
            return .debug
        case "trace":
            return .trace
        case "always":
            return .always
        default:
            return .never
        }
    }
}

extension KVAEvent {
    static func create(with event: KochavaConstants.Events) -> KVAEvent {
        switch event {
        case .addtocart:
            return KVAEvent(type: .addToCart)
        case .addtowishlist:
            return KVAEvent(type: .addToWishList)
        case .achievement:
            return KVAEvent(type: .achievement)
        case .levelcomplete:
            return KVAEvent(type: .levelComplete)
        case .purchase:
            return KVAEvent(type: .purchase)
        case .checkoutstart:
            return KVAEvent(type: .checkoutStart)
        case .rating:
            return KVAEvent(type: .rating)
        case .search:
            return KVAEvent(type: .search)
        case .tutorialcomplete:
            return KVAEvent(type: .tutorialComplete)
        case .view:
            return KVAEvent(type: .view)
        case .adview:
            return KVAEvent(type: .adView)
        case .adclick:
            return KVAEvent(type: .adClick)
        case .pushrecieved:
            return KVAEvent(type: .pushReceived)
        case .pushopened:
            return KVAEvent(type: .pushOpened)
        case .consentgranted:
            return KVAEvent(type: .consentGranted)
        case .subscribe:
            return KVAEvent(type: .subscribe)
        case .registrationcomplete:
            return KVAEvent(type: .registrationComplete)
        case .starttrial:
            return KVAEvent(type: .startTrial)
        }
    }
}
