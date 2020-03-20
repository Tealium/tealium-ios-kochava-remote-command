//
//  KochavaEventKeys.swift
//  regular-rc-test
//
//  Created by Christina S on 3/19/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
#if COCOAPODS
    import TealiumSwift
#else
    import TealiumCore
#endif

public struct KochavaEventKeys: Codable {
    var actionString: String?
    var adCampaignIdString: String?
    var adCampaignNameString: String?
    var adDeviceTypeString: String?
    var adGroupIdString: String?
    var adGroupNameString: String?
    var adMediationNameString: String?
    var adNetworkNameString: String?
    var adPlacementString: String?
    var adSizeString: String?
    var adTypeString: String?
    var appleWatchBool: Bool?
    var appleWatchIdString: String?
    var appStoreReceiptBase64EncodedString: String?
    var checkoutAsGuestString: String?
    var completedBoolNumber: Int?
    var contentIdString: String?
    var contentTypeString: String?
    var currencyString: String?
    var customEventNameString: String?
    var dateString: String?
    var descriptionString: String?
    var destinationString: String?
    var durationTimeIntervalNumber: Double?
    var endDateString: String?
    var infoDictionary: [String: AnyCodable]?
    var infoString: String?
    var itemAddedFromString: String?
    var levelString: String?
    var maxRatingValueDoubleNumber: Double?
    var nameString: String?
    var orderIdString: String?
    var quantityDoubleNumber: Double?
    var originString: String?
    var priceDoubleNumber: Double?
    var ratingValueDoubleNumber: Double?
    var receiptIdString: String?
    var referralFromString: String?
    var registrationMethodString: String?
    var searchTermString: String?
    var resultsString: String?
    var scoreString: String?
    var sourceString: String?
    var spatialXDoubleNumber: Double?
    var spatialYDoubleNumber: Double?
    var spatialZDoubleNumber: Double?
    var startDateString: String?
    var successString: String?
    var userIdString: String?
    var uriString: String?
    var userNameString: String?
    var validatedString: String?
    var identity_link_ids: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case actionString = "action"
        case adCampaignIdString = "ad_campaign_id"
        case adCampaignNameString = "ad_campaign_name"
        case adDeviceTypeString = "ad_device_type"
        case adGroupIdString = "ad_group_id"
        case adGroupNameString = "ad_group_name"
        case adMediationNameString = "ad_mediation_name"
        case adNetworkNameString = "ad_network_name"
        case adPlacementString = "placement"
        case adSizeString = "ad_size"
        case adTypeString = "ad_type"
        case appleWatchBool = "from_apple_watch"
        case appleWatchIdString = "apple_watch_id"
        case appStoreReceiptBase64EncodedString = "app_store_receipt_encoded"
        case checkoutAsGuestString = "checkout_as_guest"
        case completedBoolNumber = "completed"
        case contentIdString = "content_id"
        case contentTypeString = "content_type"
        case currencyString = "currency"
        case customEventNameString = "custom_event_name"
        case dateString = "date_now"
        case descriptionString = "description"
        case destinationString = "destination"
        case durationTimeIntervalNumber = "duration"
        case endDateString = "end_date"
        case infoDictionary = "info_dictionary"
        case infoString = "info_string"
        case itemAddedFromString = "item_added_from"
        case levelString = "level"
        case maxRatingValueDoubleNumber = "max_rating_value"
        case nameString = "name"
        case orderIdString = "order_id"
        case quantityDoubleNumber = "quantity"
        case originString = "origin"
        case priceDoubleNumber = "price"
        case ratingValueDoubleNumber = "rating_value"
        case receiptIdString = "receipt_id"
        case referralFromString = "referral_from"
        case registrationMethodString = "registration_method"
        case searchTermString = "search_term"
        case resultsString = "results"
        case scoreString = "score"
        case spatialXDoubleNumber = "spatial_x"
        case spatialYDoubleNumber = "spatial_y"
        case spatialZDoubleNumber = "spatial_z"
        case startDateString = "start_date"
        case successString = "success"
        case userIdString = "user_id"
        case uriString = "uri"
        case userNameString = "user_name"
        case validatedString = "validated"
        case identity_link_ids
    }
    
    public init(from decoder: Decoder) throws {
        let values = try? decoder.container(keyedBy: CodingKeys.self)
        actionString = try? values?.decodeIfPresent(String.self, forKey: .actionString)
        adCampaignIdString = try? values?.decodeIfPresent(String.self, forKey: .adCampaignIdString)
        adCampaignNameString = try? values?.decodeIfPresent(String.self, forKey: .adCampaignNameString)
        adDeviceTypeString = try? values?.decodeIfPresent(String.self, forKey: .adDeviceTypeString)
        adGroupIdString = try? values?.decodeIfPresent(String.self, forKey: .adGroupIdString)
        adGroupNameString = try? values?.decodeIfPresent(String.self, forKey: .adGroupNameString)
        adMediationNameString = try? values?.decodeIfPresent(String.self, forKey: .adMediationNameString)
        adNetworkNameString = try? values?.decodeIfPresent(String.self, forKey: .adNetworkNameString)
        adPlacementString = try? values?.decodeIfPresent(String.self, forKey: .adPlacementString)
        adSizeString = try? values?.decodeIfPresent(String.self, forKey: .adSizeString)
        adTypeString = try? values?.decodeIfPresent(String.self, forKey: .adTypeString)
        appleWatchBool = try? values?.decodeIfPresent(Bool.self, forKey: .appleWatchBool)
        appleWatchIdString = try? values?.decodeIfPresent(String.self, forKey: .appleWatchIdString)
        appStoreReceiptBase64EncodedString = try? values?.decodeIfPresent(String.self, forKey: .appStoreReceiptBase64EncodedString)
        checkoutAsGuestString = try? values?.decodeIfPresent(String.self, forKey: .checkoutAsGuestString)
        completedBoolNumber = try? values?.decodeIfPresent(Int.self, forKey: .completedBoolNumber)
        contentIdString = try? values?.decodeIfPresent(String.self, forKey: .contentIdString)
        contentTypeString = try? values?.decodeIfPresent(String.self, forKey: .contentTypeString)
        currencyString = try? values?.decodeIfPresent(String.self, forKey: .currencyString)
        customEventNameString = try? values?.decodeIfPresent(String.self, forKey: .customEventNameString)
        dateString = try? values?.decodeIfPresent(String.self, forKey: .dateString)
        descriptionString = try? values?.decodeIfPresent(String.self, forKey: .descriptionString)
        destinationString = try? values?.decodeIfPresent(String.self, forKey: .destinationString)
        durationTimeIntervalNumber = try? values?.decodeIfPresent(Double.self, forKey: .durationTimeIntervalNumber)
        endDateString = try? values?.decodeIfPresent(String.self, forKey: .endDateString)
        infoDictionary = try? values?.decodeIfPresent([String: AnyCodable].self, forKey: .infoDictionary)
        infoString = try? values?.decodeIfPresent(String.self, forKey: .infoString)
        itemAddedFromString = try? values?.decodeIfPresent(String.self, forKey: .itemAddedFromString)
        levelString = try? values?.decodeIfPresent(String.self, forKey: .levelString)
        maxRatingValueDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .maxRatingValueDoubleNumber)
        nameString = try? values?.decodeIfPresent(String.self, forKey: .nameString)
        orderIdString = try? values?.decodeIfPresent(String.self, forKey: .orderIdString)
        quantityDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .quantityDoubleNumber)
        originString = try? values?.decodeIfPresent(String.self, forKey: .originString)
        priceDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .priceDoubleNumber)
        ratingValueDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .ratingValueDoubleNumber)
        receiptIdString = try? values?.decodeIfPresent(String.self, forKey: .receiptIdString)
        referralFromString = try? values?.decodeIfPresent(String.self, forKey: .referralFromString)
        registrationMethodString = try? values?.decodeIfPresent(String.self, forKey: .registrationMethodString)
        searchTermString = try? values?.decodeIfPresent(String.self, forKey: .searchTermString)
        resultsString = try? values?.decodeIfPresent(String.self, forKey: .resultsString)
        scoreString = try? values?.decodeIfPresent(String.self, forKey: .scoreString)
        spatialXDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .spatialXDoubleNumber)
        spatialYDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .spatialYDoubleNumber)
        spatialZDoubleNumber = try? values?.decodeIfPresent(Double.self, forKey: .spatialZDoubleNumber)
        startDateString = try? values?.decodeIfPresent(String.self, forKey: .startDateString)
        successString = try? values?.decodeIfPresent(String.self, forKey: .successString)
        userIdString = try? values?.decodeIfPresent(String.self, forKey: .userIdString)
        uriString = try? values?.decodeIfPresent(String.self, forKey: .uriString)
        userNameString = try? values?.decodeIfPresent(String.self, forKey: .userNameString)
        validatedString = try? values?.decodeIfPresent(String.self, forKey: .validatedString)
        identity_link_ids = try? values?.decodeIfPresent([String: String].self, forKey: .identity_link_ids)
    }
    
    static var lookup: [String: String] = [
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
        "now_date": "dateString",
        "description": "descriptionString",
        "destination": "destinationString",
        "duratiion": "durationTimeIntervalNumber",
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


