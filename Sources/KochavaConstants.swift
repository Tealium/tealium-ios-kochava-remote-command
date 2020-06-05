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
    static let errorPrefix = "Tealium Kochava: "
    
    enum Keys {
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
        static let customEventNameString = "custom_event_name"
        static let eventPayload = "event_parameters"
        static let infoDictionary = "info_dictionary"
    }
    
    enum Commands: String {
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
    
    static let eventParameters = [
        "action": "actionString",
        "ad_campaign_id": "adCampaignIdString",
        "ad_campaign_name": "adCampaignNameString",
        "ad_device_type": "adDeviceTypeString",
        "ad_group_id": "adGroupIdString",
        "ad_group_name": "adGroupNameString",
        "ad_mediation_name": "adMediationNameString",
        "ad_network_name": "adNetworkNameString",
        "placement": "adPlacementString",
        "ad_size": "adSizeString",
        "ad_type": "adTypeString",
        "from_apple_watch": "appleWatchBool",
        "apple_watch_id": "appleWatchIdString",
        "app_store_receipt_encoded": "appStoreReceiptBase64EncodedString",
        "checkout_as_guest": "checkoutAsGuestString",
        "completed": "completedBoolNumber",
        "content_id": "contentIdString",
        "content_type": "contentTypeString",
        "currency": "currencyString",
        "custom_event_name": "customEventNameString",
        "date_now": "dateString",
        "description": "descriptionString",
        "destination": "destinationString",
        "duration": "durationTimeIntervalNumber",
        "end_date": "endDateString",
        "info_dictionary": "infoDictionary",
        "info_string": "infoString",
        "item_added_from": "itemAddedFromString",
        "level": "levelString",
        "max_rating_value": "maxRatingValueDoubleNumber",
        "name": "nameString",
        "order_id": "orderIdString",
        "quantity": "quantityDoubleNumber",
        "origin": "originString",
        "price": "priceDoubleNumber",
        "rating_value": "ratingValueDoubleNumber",
        "receipt_id": "receiptIdString",
        "referral_from": "referralFromString",
        "registration_method": "registrationMethodString",
        "search_term": "searchTermString",
        "results": "resultsString",
        "score": "scoreString",
        "spatial_x": "spatialXDoubleNumber",
        "spatial_y": "spatialYDoubleNumber",
        "spatial_z": "spatialZDoubleNumber",
        "start_date": "startDateString",
        "success": "successString",
        "user_id": "userIdString",
        "uri": "uriString",
        "user_name": "userNameString",
        "validated": "validatedString"
    ]

}


