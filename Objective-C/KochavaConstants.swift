//
//  KochavaConstants.swift
//  TealiumKochava
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

enum KochavaConstants {
    
    static let commandName = "command_name"
    static let separator: Character = ","
    static let errorPrefix = "Kochava Error: "
    
    enum ConfigKey: String {
        case command = "command_name"
        case apiKey = "app_guid"
        case logLevel = "log_level"
        case retrieveAttributionData = "retrieve_attribution_data"
        case identityLinks = "identity_link_ids"
        case limitAdTracking = "limit_ad_tracking"
        case sendDeviceId = "send_device_id"
        case sendSDKVersion = "send_sdk_version"
        case sleepTracker = "sleep_tracker"
        case kvaDeviceID = "kva_device_id"
        case kvaSDKVersion = "kva_sdk_version"
    }
    
    enum Commands: String  {
        case configure = "configure"
        case sleeptracker = "sleepTracker"
        case invalidate = "invalidate"
        case sendidentitylink = "sendidentitylink"
        case custom = "custom"
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

    enum EventKeys: String {
        case customEventNameString = "customEventNameString"
        case infoDictionary = "infoDictionary"
        case infoString = "infoString"
    }
    
}


