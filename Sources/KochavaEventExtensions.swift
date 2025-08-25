import Foundation
import KochavaMeasurement

/// Extension to Event class providing utility methods for parameter mapping
/// Provides type-safe parameter assignment without Key-Value Coding risks
extension Event {
    
    /// Set multiple parameters on the event from a dictionary
    /// Maps JSON payload keys to Event properties safely
    /// Reference: https://kochava.github.io/Apple-SwiftPackage-KochavaMeasurement/documentation/kochavameasurement/event/#Parameters-Standard
    func setParameters(from dictionary: [String: Any]) {
        for (key, value) in dictionary {
            switch key {
            // String properties
            case "action": self.actionString = value as? String
            case "ad_campaign_id": self.adCampaignIdString = value as? String
            case "ad_campaign_name": self.adCampaignNameString = value as? String
            case "ad_device_type": self.adDeviceTypeString = value as? String
            case "ad_group_id": self.adGroupIdString = value as? String
            case "ad_group_name": self.adGroupNameString = value as? String
            case "ad_mediation_name": self.adMediationNameString = value as? String
            case "ad_network_name": self.adNetworkNameString = value as? String
            case "apple_watch_id": self.appleWatchIdString = value as? String
            case "placement": self.adPlacementString = value as? String
            case "ad_size": self.adSizeString = value as? String
            case "ad_type": self.adTypeString = value as? String
            case "app_store_receipt_encoded": self.appStoreReceiptBase64EncodedString = value as? String
            case "checkout_as_guest": self.checkoutAsGuestString = value as? String
            case "content_id": self.contentIdString = value as? String
            case "content_type": self.contentTypeString = value as? String
            case "currency": self.currencyString = value as? String
            case "custom_event_name": self.customEventName = value as? String
            case "date_string": self.dateString = value as? String
            case "description": self.descriptionString = value as? String
            case "destination": self.destinationString = value as? String
            case "end_date_string": self.endDateString = value as? String
            case "info_string": self.infoString = value as? String
            case "item_added_from": self.itemAddedFromString = value as? String
            case "level": self.levelString = value as? String
            case "name": self.nameString = value as? String
            case "order_id": self.orderIdString = value as? String
            case "origin": self.originString = value as? String
            case "receipt_id": self.receiptIdString = value as? String
            case "referral_from": self.referralFromString = value as? String
            case "registration_method": self.registrationMethodString = value as? String
            case "results": self.resultsString = value as? String
            case "score": self.scoreString = value as? String
            case "search_term": self.searchTermString = value as? String
            case "source": self.sourceString = value as? String
            case "start_date_string": self.startDateString = value as? String
            case "success": self.successString = value as? String
            case "user_id": self.userIdString = value as? String
            case "uri": self.uriString = value as? String
            case "user_name": self.userNameString = value as? String
            case "validated": self.validatedString = value as? String
            
            // Boolean properties
            case "apple_watch": self.appleWatchBool = value as? Bool ?? false
            
            // Boolean NSNumber properties
            case "background": self.backgroundBoolNumber = Self.toBooleanNSNumber(value)
            case "completed": self.completedBoolNumber = Self.toBooleanNSNumber(value)
            
            // Double properties wrapped in NSNumber
            case "duration": self.durationTimeIntervalNumber = Self.toNSNumber(value)
            case "max_rating_value": self.maxRatingValueDoubleNumber = Self.toNSNumber(value)
            case "price_double": self.priceDoubleNumber = Self.toNSNumber(value)
            case "quantity": self.quantityDoubleNumber = Self.toNSNumber(value)
            case "rating_value": self.ratingValueDoubleNumber = Self.toNSNumber(value)
            case "spatial_x": self.spatialXDoubleNumber = Self.toNSNumber(value)
            case "spatial_y": self.spatialYDoubleNumber = Self.toNSNumber(value)
            case "spatial_z": self.spatialZDoubleNumber = Self.toNSNumber(value)
            
            // Date properties
            case "date_object": self.date = value as? Date
            case "end_date_object": self.endDate = value as? Date
            case "start_date_object": self.startDate = value as? Date
            
            // Dictionary properties
            case "info_dictionary": self.infoDictionary = value as? [AnyHashable: Any]
            case "payload": self.payloadDictionary = value as? [AnyHashable: Any]
            
            // NSDecimalNumber properties
            case "price_decimal": self.priceDecimalNumber = value as? NSDecimalNumber
            
            default:
                // Forward compatibility: Unknown properties preserved in infoDictionary
                // Ensures new Kochava Event properties are not lost in analytics
                var info = self.infoDictionary ?? [:]
                info[key] = value
                self.infoDictionary = info
            }
        }
    }
    
    /// Helper function to safely convert Any value to NSNumber
    /// Handles Int, Double, Float, and existing NSNumber values
    private static func toNSNumber(_ value: Any) -> NSNumber? {
        switch value {
        case let intValue as Int:
            return NSNumber(value: intValue)
        case let doubleValue as Double:
            return NSNumber(value: doubleValue)
        case let floatValue as Float:
            return NSNumber(value: floatValue)
        case let numberValue as NSNumber:
            return numberValue
        default:
            return nil
        }
    }
    
    /// Helper function to convert Any value to Boolean NSNumber
    /// Handles Bool values and Int values (0 = false, non-zero = true)
    private static func toBooleanNSNumber(_ value: Any) -> NSNumber? {
        switch value {
        case let boolValue as Bool:
            return NSNumber(value: boolValue)
        case let intValue as Int:
            return NSNumber(value: intValue != 0)
        default:
            return nil
        }
    }
}
