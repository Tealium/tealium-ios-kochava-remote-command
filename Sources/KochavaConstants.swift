//
//  KochavaConstants.swift
//  TealiumKochava
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
import KochavaMeasurement

enum KochavaConstants {
    
    static let commandId = "kochava"
    static let description = "Kochava Remote Command"
    static let commandName = "command_name"
    static let separator: Character = ","
    static let errorPrefix = "Tealium Kochava: "
    static let version = "2.0.0"

    enum Configuration {
        static let appGuid = "app_guid"
        static let debug = "debug"
        static let logLevel = "log_level"
        
        /// Identity Links configuration
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/identitylinking-swift.property/
        static let identityLinks = "identity_link_ids"
        
        /// App Tracking Transparency (ATT) configuration
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/apptrackingtransparency/
        static let attEnabled = "app_tracking_transparency_enabled"
        static let attWaitTime = "att_authorization_wait_time"
        static let attAutoRequest = "att_auto_request_authorization"
        
        /// Limit Ad Tracking configuration
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/applimitadtracking-swift.property/
        static let limitAdTracking = "limit_ad_tracking"

        /// Sleep mode configuration
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/sleepbool/
        static let sleep = "sleep"

        /// Configuration parameters
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/configure(with:context:)
        static let configParams = "configuration_params"
    }
    
    /// Identity Link parameters
    enum IdentityLink {
        static let identityLinks = "identity_link_ids"
    }
    
    /// Custom Identifiers parameters
    enum CustomIdentifiers {
        static let customIdentifiers = "custom_identifiers"
    }
    
    /// Custom Values parameters
    enum CustomValues {
        static let customValues = "custom_values"
    }
    
    /// Limit Ad Tracking parameters
    enum LimitAdTracking {
        static let limitAdTracking = "limit_ad_tracking"
    }
    
    /// Sleep mode command payload keys
    enum Sleep {
        static let sleep = "sleep"
    }
    
    enum Event {
        static let event = "event"
    }
    
    /// Privacy profile command payload keys
    enum PrivacyProfile {
        static let profileName = "privacy_profile_name"
        static let datapoints = "privacy_datapoints"
        static let enabled = "privacy_enabled"
    }
    
    /// Remote Command identifiers for Kochava SDK operations
    enum Commands: String {
        case initialize = "initialize"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/applimitadtracking-swift.property/
        case setAppLimitAdTracking = "setapplimitadtracking"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/identitylinking-swift.property/
        case setIdentityLinks = "setidentitylinks"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/customidentifiers-swift.property
        case setCustomIdentifiers = "setcustomidentifiers"
        
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/customvalues-swift.property
        case setCustomValues = "setcustomvalues"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/sleepbool/
        case setSleep = "setsleep"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/invalidate()/
        case invalidate = "invalidate"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/start()/
        case start = "start"

        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/stop()/
        case stop = "stop"
        
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement/privacy
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaNetworking/documentation/kochavanetworking/networking/privacy-swift.class
        case createPrivacyProfile = "createprivacyprofile"
        case setPrivacyProfile = "setprivacyprofile"
    }
    
    /// Event type mapping from JSON payload values to Kochava Event_Type
    /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/event_type/
    static let eventTypes: [String: Event_Type] = [
        // Standard event types (from Kochava Event_Type)
        "achievement": .achievement,
        "adclick": .adClick,
        "adview": .adView,
        "addtocart": .addToCart,
        "addtowishlist": .addToWishList,
        "checkoutstart": .checkoutStart,
        "consentgranted": .consentGranted,
        "custom": .custom,
        "deeplink": .deeplink,
        "levelcomplete": .levelComplete,
        "purchase": .purchase,
        "pushopened": .pushOpened,
        "pushreceived": .pushReceived,
        "rating": .rating,
        "registrationcomplete": .registrationComplete,
        "search": .search,
        "starttrial": .startTrial,
        "subscribe": .subscribe,
        "tutorialcomplete": .tutorialComplete,
        "view": .view,
    ]
    
    /// Check if event type is supported (either predefined or via alias)
    static func isValidEventType(_ eventType: String) -> Bool {
        return eventTypes.keys.contains(eventType)
    }
    
            
    /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaNetworking/documentation/kochavanetworking/log/level-swift.class/
    enum LogLevel {
        /// Log level mapping from JSON payload values to Kochava Log.Level
        static let mapping: [String: Log.Level] = [
            "never": .never,    // Never prints visibly in the log
            "error": .error,    // Fatal errors
            "warn": .warn,      // Non-fatal warnings
            "info": .info,      // General information, basic initialization and API calls (default)
            "debug": .debug,    // Low-level messages for verifying integration, includes transaction payloads
            "trace": .trace,    // Very low-level messages for tracing issue origin
            "always": .always   // Always prints visibly in the log
        ]
        
        /// Check if log level is supported
        static func isValid(_ level: String) -> Bool {
            return mapping.keys.contains(level.lowercased())
        }
        
        /// Get Kochava Log.Level for string value
        static func get(for level: String) -> Log.Level? {
            return mapping[level.lowercased()]
        }
    }
}


