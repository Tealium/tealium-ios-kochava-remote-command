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
            case .setAppLimitAdTracking:
                executeLimitAdTracking(with: payload)
            case .setIdentityLinks:
                executeSetIdentityLinks(with: payload)
            case .setCustomIdentifiers:
                executeSetCustomIdentifiers(with: payload)
            case .setCustomValues:
                executeSetCustomValues(with: payload)
            case .setSleep:
                executeSetSleep(with: payload)
            case .invalidate:
                executeInvalidate()
            case .start:
                executeStart()
            case .stop:
                executeStop()
            case .createPrivacyProfile:
                executeCreatePrivacyProfile(with: payload)
            case .setPrivacyProfile:
                executeSetPrivacyProfile(with: payload)
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
        
        configureLogLevel(with: payload)
        configureMeasurementParams(with: payload)
        configureAppTrackingTransparency(with: payload)
        configureLimitAdTracking(with: payload)
        
        // Initialize Kochava
        kochavaInstance.initialize(appGuid: appGuid)
        
        // Configure settings after initialization
        configureIdentityLinks(with: payload)
        configureSleep(with: payload)
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
        kochavaInstance.setIdentityLinks(with: identityLinks)
    }
    
    private func configureSleep(with payload: [String: Any]) {
        if let sleepInt = payload[KochavaConstants.Configuration.sleep] as? Int {
            kochavaInstance.setSleep(sleepInt != 0)
        } else if let sleepBool = payload[KochavaConstants.Configuration.sleep] as? Bool {
            kochavaInstance.setSleep(sleepBool)
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
                print("\(KochavaConstants.errorPrefix)configureAppTrackingTransparency - app_tracking_transparency_enabled not provided")
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
    
    private func executeSetIdentityLinks(with payload: [String: Any]) {
        guard let identityLinks = payload[KochavaConstants.IdentityLink.identityLinks] as? [String: String] else {
            if debug {
                print("\(KochavaConstants.errorPrefix)setIdentityLinks - identity_link_ids must be a dictionary of strings")
            }
            return
        }
        kochavaInstance.setIdentityLinks(with: identityLinks)
    }
    
    private func executeSetCustomIdentifiers(with payload: [String: Any]) {
        guard let customIdentifiers = payload[KochavaConstants.CustomIdentifiers.customIdentifiers] as? [String: String] else {
            if debug {
                print("\(KochavaConstants.errorPrefix)setCustomIdentifiers - custom_identifiers must be a dictionary of strings")
            }
            return
        }
        kochavaInstance.setCustomIdentifiers(with: customIdentifiers)
    }
    
    private func executeSetCustomValues(with payload: [String: Any]) {
        guard let customValues = payload[KochavaConstants.CustomValues.customValues] as? [String: Any] else {
            if debug {
                print("\(KochavaConstants.errorPrefix)setCustomValues - custom_values must be a dictionary")
            }
            return
        }
        kochavaInstance.setCustomValues(with: customValues)
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Set \(customValues.count) custom values")
        }
    }
    
    private func executeSetSleep(with payload: [String: Any]) {
        guard let sleep = payload[KochavaConstants.Sleep.sleep] as? Bool else {
            if debug {
                print("\(KochavaConstants.errorPrefix)setSleep - sleep must be a boolean")
            }
            return
        }
        kochavaInstance.setSleep(sleep)
    }
    
    private func executeInvalidate() { 
        kochavaInstance.invalidate()
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Kochava measurement instance invalidated")
        }
    }
    
    private func configureMeasurementParams(with payload: [String: Any]) {
        guard let configParams = payload[KochavaConstants.Configuration.configParams] else {
            return
        }
        
        kochavaInstance.configure(with: configParams)
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Applied configuration_params during initialization")
        }
    }
    
    private func executeStart() {
        kochavaInstance.start()
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Kochava measurement instance started (resumed)")
        }
    }
    
    private func executeStop() {
        kochavaInstance.stop()
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Kochava measurement instance stopped (paused)")
        }
    }
    
    private func executeCreatePrivacyProfile(with payload: [String: Any]) {
        guard let profileName = payload[KochavaConstants.PrivacyProfile.profileName] as? String else {
            if debug {
                print("\(KochavaConstants.errorPrefix)createPrivacyProfile - privacy_profile_name is required")
            }
            return
        }
        
        guard let datapoints = payload[KochavaConstants.PrivacyProfile.datapoints] as? [String] else {
            if debug {
                print("\(KochavaConstants.errorPrefix)createPrivacyProfile - privacy_datapoints must be an array of strings")
            }
            return
        }
        
        kochavaInstance.createPrivacyProfile(name: profileName, datapoints: datapoints)
        
        if debug {
            print("\(KochavaConstants.errorPrefix)Created privacy profile '\(profileName)' with \(datapoints.count) datapoint(s): \(datapoints.joined(separator: ", "))")
        }
    }
    
    private func executeSetPrivacyProfile(with payload: [String: Any]) {
        guard let profileName = payload[KochavaConstants.PrivacyProfile.profileName] as? String else {
            if debug {
                print("\(KochavaConstants.errorPrefix)setPrivacyProfile - privacy_profile_name is required")
            }
            return
        }
        
        let enabled = payload[KochavaConstants.PrivacyProfile.enabled] as? Bool ?? false
        
        kochavaInstance.setPrivacyProfile(name: profileName, enabled: enabled)
        
        if debug {
            let status = enabled ? "enabled" : "disabled"
            print("\(KochavaConstants.errorPrefix)Privacy profile '\(profileName)' \(status)")
        }
    }

}
