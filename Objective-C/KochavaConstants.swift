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
    
    enum Keys: String {
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
        case customEventNameString = "custom_event_name"
        case eventPayload = "event_parameters"
        case infoDictionary = "info_dictionary"
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


