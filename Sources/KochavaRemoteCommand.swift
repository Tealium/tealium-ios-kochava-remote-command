//
//  KochavaRemoteCommand.swift
//  TealiumKochava
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import KochavaNetworking
import KochavaMeasurement
import KochavaTracking
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
    import TealiumRemoteCommands
#endif


public class KochavaRemoteCommand: RemoteCommand {

    var kochavaInstance: KochavaCommand 
    var debug = false 

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

    public func onReady(_ onReady: @escaping () -> Void) {
        kochavaInstance.onReady(onReady)
    }

    func processRemoteCommand(with payload: [String: Any]) {
        guard let command = payload[KochavaConstants.commandName] as? String else {
            if debug {
                print("\(KochavaConstants.errorPrefix)Missing command_name or kochavaInstance not initialized")
            }
            return
        }
        
        if let tagDebug = payload[KochavaConstants.Configuration.debug] as? Bool, tagDebug == true {
            debug = true
        }
        
        let commands = command.split(separator: KochavaConstants.separator)
        let kochavaCommands = commands.map { command in
            return command.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        kochavaCommands.forEach {
            let command = KochavaConstants.Commands(rawValue: $0.lowercased())
            
            switch command {
            case .initialize:
                executeInitialize(with: payload)
            case .enableAppLimitAdTracking, .setAppLimitAdTracking:
                executeLimitAdTracking(with: payload)
            case .sendIdentityLink:
                executeIdentityLink(with: payload)
            case .sleepTracker:
                executeSleepTracker(with: payload)
            case .invalidate:
                executeInvalidate()
            default:
                executeSendEvent(eventName: $0.lowercased(), with: payload)
            }
        }
    }
    
    private func executeInitialize(with payload: [String: Any]) {
        guard let appGuid = payload[KochavaConstants.Configuration.appGuid] as? String else {
            if debug {
                print("\(KochavaConstants.errorPrefix)initialize - app_guid is required")
            }
            return
        }
        
        // Configure settings before initialization
        configureAppTrackingTransparency(with: payload)
        configureLogLevel(with: payload)
        configureLimitAdTracking(with: payload)
        
        // Initialize Kochava
        kochavaInstance.initialize(appGuid: appGuid)
        
        // Configure settings after initialization
        configureIdentityLinks(with: payload)
        configureSleepTracker(with: payload)
    }
    
    // MARK: - Configuration Helper Methods
    
    private func configureLogLevel(with payload: [String: Any]) {
        guard let logLevel = payload[KochavaConstants.Configuration.logLevel] as? String else {
            return
        }
        
        if let mappedLogLevel = KochavaConstants.LogLevel.get(for: logLevel) {
            kochavaInstance.setLogLevel(mappedLogLevel)
        } else if debug {
            let validLevels = Array(KochavaConstants.LogLevel.mapping.keys).sorted().joined(separator: ", ")
            print("\(KochavaConstants.errorPrefix)initialize - invalid log_level '\(logLevel)'. Valid levels: \(validLevels)")
        }
    }
    
    private func configureLimitAdTracking(with payload: [String: Any]) {
        if let limitAdTrackingInt = payload[KochavaConstants.Configuration.limitAdTracking] as? Int {
            kochavaInstance.setLimitAdTracking(limitAdTrackingInt != 0)
        } else if let limitAdTrackingBool = payload[KochavaConstants.Configuration.limitAdTracking] as? Bool {
            kochavaInstance.setLimitAdTracking(limitAdTrackingBool)
        }
    }
    
    private func configureIdentityLinks(with payload: [String: Any]) {
        guard let identityLinks = payload[KochavaConstants.Configuration.identityLinks] as? [String: String] else {
            return
        }
        kochavaInstance.sendIdentityLink(with: identityLinks)
    }
    
    private func configureSleepTracker(with payload: [String: Any]) {
        if let sleepInt = payload[KochavaConstants.Configuration.sleepTracker] as? Int {
            kochavaInstance.sleepTracker(sleepInt != 0)
        } else if let sleepBool = payload[KochavaConstants.Configuration.sleepTracker] as? Bool {
            kochavaInstance.sleepTracker(sleepBool)
        }
    }
    
    private func executeLimitAdTracking(with payload: [String: Any]) {
        guard let limitAdTracking = payload[KochavaConstants.LimitAdTracking.limitAdTracking] as? Bool else {
            if debug {
                print("\(KochavaConstants.errorPrefix)limitAdTracking - limit_ad_tracking must be a boolean")
            }
            return
        }
        kochavaInstance.setLimitAdTracking(limitAdTracking)
    }
    
    private func configureAppTrackingTransparency(with payload: [String: Any]) {
        guard let attEnabled = payload[KochavaConstants.Configuration.attEnabled] as? Bool else {
            if debug {
                print("\(KochavaConstants.errorPrefix)configureAppTrackingTransparency - att_enabled not provided")
            }
            return
        }
        
        let waitTime = payload[KochavaConstants.Configuration.attWaitTime] as? Double
        let autoRequest = payload[KochavaConstants.Configuration.attAutoRequest] as? Bool
        
        kochavaInstance.setAppTrackingTransparency(enabled: attEnabled, waitTime: waitTime, autoRequest: autoRequest)
    }
    
    private func executeSendEvent(eventName: String, with payload: [String: Any]) {
        let event: Event
        if KochavaConstants.isValidEventType(eventName) {
            // Known predefined event - use typeNameString for forward compatibility
            event = Event(typeNameString: eventName)
        } else {
            // Unknown event - treat as custom for proper analytics
            event = Event(customWithEventName: eventName)
        }
        
        // Add event parameters directly (event.name, event.currency, etc.)
        if let eventParams = payload[KochavaConstants.Event.event] as? [String: Any] {
            event.setParameters(from: eventParams)
            if debug {
                print("\(KochavaConstants.errorPrefix)Added \(eventParams.count) event parameters")
            }
        }
        
        kochavaInstance.send(event: event)
    }
    
    private func executeIdentityLink(with payload: [String: Any]) {
        guard let identityLink = payload[KochavaConstants.IdentityLink.identityLinks] as? [String: String] else {
            if debug {
                print("\(KochavaConstants.errorPrefix)sendIdentityLink - identity_link_ids must be a dictionary of strings")
            }
            return
        }
        kochavaInstance.sendIdentityLink(with: identityLink)
    }
    
    private func executeSleepTracker(with payload: [String: Any]) {
        guard let sleep = payload[KochavaConstants.SleepTracker.sleepTracker] as? Bool else {
            if debug {
                print("\(KochavaConstants.errorPrefix)sleepTracker - sleep_tracker must be a boolean")
            }
            return
        }
        kochavaInstance.sleepTracker(sleep)
    }
    
    private func executeInvalidate() { 
        kochavaInstance.invalidate()
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Kochava measurement instance invalidated")
        }
    }

}
