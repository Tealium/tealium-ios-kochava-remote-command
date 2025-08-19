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
        static let identityLinks = "identity_link_ids"
        
        /// App Tracking Transparency (ATT) configuration
        /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/measurement_apptrackingtransparency
        static let attEnabled = "app_tracking_transparency_enabled"
        static let attWaitTime = "att_authorization_wait_time"
        static let attAutoRequest = "att_auto_request_authorization"
        
        static let limitAdTracking = "limit_ad_tracking"
        static let sleepTracker = "sleep_tracker"
        static let configParams = "configuration_params"
    }
    
    /// Identity Link command payload keys
    enum IdentityLink {
        static let identityLinks = "identity_link_ids"
    }
    
    /// Limit Ad Tracking command payload keys  
    enum LimitAdTracking {
        static let limitAdTracking = "limit_ad_tracking"
    }
    
    /// Sleep Tracker command payload keys
    enum SleepTracker {
        static let sleepTracker = "sleep_tracker"
    }
    
    enum Event {
        static let event = "event"
    }
    
    enum Commands: String {
        case initialize = "initialize"
        case enableAppLimitAdTracking = "enableapplimitadtracking"
        case setAppLimitAdTracking = "setapplimitadtracking"
        case sendIdentityLink = "sendidentitylink"
        case sleepTracker = "sleeptracker"
        case invalidate = "invalidate" 
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
        "pushrecieved": .pushReceived,
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


