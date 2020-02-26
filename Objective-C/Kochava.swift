//
//  Kochava.swift
//  TealiumKochava
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

enum Kochava {
    
    static let commandName = "command_name"
    
    enum ConfigKey {
        static let command = "command_name"
        static let apiKey = "app_guid"
        static let logLevel = "log_level"
        static let retrieveAttributionData = "retrieve_attribution_data"
        static let identityLinks = "identity_link_ids"
        static let limitAdTracking = "limit_ad_tracking"
        static let sendDeviceId = "send_device_id"
        static let sendSDKVersion = "send_sdk_version"
        static let sleepTracker = "sleep_tracker"
        static let kvaDeviceID = "kva_device_id"
        static let kvaSDKVersion = "kva_sdk_version"
    }
    
    // remove CaseIterable when done testing
    enum Commands: CaseIterable {
        static let configure = "configure"
        static let sleeptracker = "sleepTracker"
        static let invalidate = "invalidate"
        static let sendidentitylink = "sendidentitylink"
        static let custom = "custom"
    }
    
    enum Events: String, CaseIterable {
        case addtocart
        case addtowishlist
        case achievement
        case levelcomplete
        case purchase
        case checkoutstart
        case rating
        case search
        case registrationcomplete
        case tutorialcomplete
        case view
        case adclick
        case adview
        case pushrecieved
        case pushopened
        case consentgranted
        case subscribe
        case starttrial
    }
    
    enum EventKeys {
        static let customEventNameString = "customEventNameString"
        static let infoDictionary = "infoDictionary"
        static let infoString = "infoString"
    }
    
}


