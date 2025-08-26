//
//  TealiumHelper.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import Combine
import TealiumCore
import TealiumRemoteCommands
import TealiumLifecycle
import TealiumTagManagement
import TealiumKochava

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "kochava"
    static let environment = "dev"
}

class TealiumHelper: ObservableObject {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
        profile: TealiumConfiguration.profile,
        environment: TealiumConfiguration.environment)

    var tealium: Tealium? 
    
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .debug
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.TagManagement, Dispatchers.RemoteCommands]
                
        tealium = Tealium(config: config) { [weak self] _ in
            guard let self = self,
                  let remoteCommands = self.tealium?.remoteCommands else {
                return
            }
            
            // Używamy lokalnego pliku JSON z backupem zdalnym
            let kochavaRemoteCommand = KochavaRemoteCommand(
                type: .local(file: "kochava")
            )
            
            // Set callback for when Kochava is ready
            kochavaRemoteCommand.onReady {
                print("🚀 Kochava SDK is ready!")
            }
            
            remoteCommands.add(kochavaRemoteCommand) 
        }
    }



    public func start() {
        _ = TealiumHelper.shared
    }

    func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        tealium?.track(tealiumView)
    }

    func trackScreen(_ name: String) {
        trackView(title: "screen_view", data: ["screen_name": name])
    }

    func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        tealium?.track(tealiumEvent)
    }
    
    func trackPurchase(orderId: String, total: Double, currency: String, products: [[String: Any]]?) {
        var purchaseData: [String: Any] = [
            "order_id": orderId,
            "order_total": total,
            "currency_code": currency,
            "event_type": "purchase"
        ]
        
        if let products = products {
            purchaseData["products"] = products
        }
        
        trackEvent(title: "order", data: purchaseData)
    }
    
    func trackAchievement(achievementId: String, description: String? = nil) {
        var achievementData: [String: Any] = [
            "achievement_id": achievementId
        ]
        
        if let description = description {
            achievementData["description"] = description
        }
        
        trackEvent(title: "unlock_achievement", data: achievementData)
    }

    func trackLevelComplete(level: String, score: Int? = nil, duration: TimeInterval? = nil) {
        var levelData: [String: Any] = [
            "level": level,
            "completed": true
        ]
        
        if let score = score {
            levelData["score"] = score
        }
        
        if let duration = duration {
            levelData["duration"] = duration
        }
        
        trackEvent(title: "level_complete", data: levelData)
    }
    
    func trackRegistration(userId: String, method: String, userData: [String: Any]? = nil) {
        var registrationData: [String: Any] = [
            "customer_id": userId,
            "signup_method": method
        ]
        
        if let userData = userData {
            registrationData.merge(userData) { (_, new) in new }
        }
        
        trackEvent(title: "user_register", data: registrationData)
    }
    
    func trackLogin(userId: String, method: String) {
        let loginData: [String: Any] = [
            "customer_id": userId,
            "signup_method": method
        ]
        
        trackEvent(title: "user_login", data: loginData)
    }
    
    func trackAdEvent(eventType: String, networkName: String, campaignId: String? = nil) {
        var adData: [String: Any] = [
            "ad_network_name": networkName
        ]
        
        if let campaignId = campaignId {
            adData["campaign_id"] = campaignId
        }
        
        trackEvent(title: eventType, data: adData)
    }
    
    func testSleepTracker(enabled: Bool) {
        let sleepData: [String: Any] = [
            "sleep": enabled
        ]
        
        trackEvent(title: "setsleep", data: sleepData)
    }
    
    func testInvalidate() {
        trackEvent(title: "invalidate", data: nil)
    }

    /// Set Identity Links to connect user identities
    func setIdentityLinks(identities: [String: String]) {
        let identityData: [String: Any] = [
            "identity_link_ids": identities
        ]
        
        trackEvent(title: "setidentitylinks", data: identityData)
    }
    
    func setIdentityLink(name: String, identifier: String) {
        setIdentityLinks(identities: [name: identifier])
    }
    
    func linkUserIdentities(userId: String, email: String? = nil, username: String? = nil, customerId: String? = nil) {
        var identities: [String: String] = [
            "User ID": userId
        ]
        
        if let email = email {
            identities["Email"] = email
        }
        
        if let username = username {
            identities["Login"] = username
        }
        
        if let customerId = customerId {
            identities["Customer ID"] = customerId
        }
        
        setIdentityLinks(identities: identities)
    }
    
    func trackDeeplink(url: String, type: String = "standard", activityType: String? = nil, sourceApp: String? = nil) {
        var deeplinkData: [String: Any] = [
            "deeplink_url": url,
            "deeplink_type": type
        ]
        
        if let activityType = activityType {
            deeplinkData["activity_type"] = activityType
        }
        
        if let sourceApp = sourceApp {
            deeplinkData["source_application"] = sourceApp
        }
        
        trackEvent(title: "deeplink_test", data: deeplinkData)
    }
    
    func trackUrlSchemeOpened(url: String, scheme: String, sourceApp: String? = nil) {
        trackDeeplink(url: url, type: "url_scheme", sourceApp: sourceApp)
    }
    
    func trackAppLaunchWithoutDeeplink(launchType: String = "normal") {
        let launchData: [String: Any] = [
            "launch_type": launchType,
            "deeplink_processed": false
        ]
        
        trackEvent(title: "app_launch_no_deeplink", data: launchData)
    }
    
    func setCustomValues(_ customValues: [String: Any]) {
        let customValuesData: [String: Any] = [
            "custom_values": customValues
        ]
        
        trackEvent(title: "set_custom_values", data: customValuesData)
    }
    
    func setCustomValue(name: String, value: Any) {
        setCustomValues([name: value])
    }
    
    func setUserTier(_ tier: String) {
        setCustomValue(name: "subscription_tier", value: tier)
    }
    
    func setAppLimitAdTracking(_ enabled: Bool) {
        let limitAdData: [String: Any] = [
            "limit_ad_tracking": enabled
        ]
        
        trackEvent(title: "setapplimitadtracking", data: limitAdData)
    }
    
    func setCustomIdentifiers(_ identifiers: [String: String]) {
        let identifierData: [String: Any] = [
            "custom_identifiers": identifiers
        ]
        
        trackEvent(title: "setcustomidentifiers", data: identifierData)
    }
    
    func startTracking() {
        trackEvent(title: "start", data: nil)
    }
    
    func stopTracking() {
        trackEvent(title: "stop", data: nil)
    }
    
    func createPrivacyProfile(name: String, datapoints: [String]) {
        let privacyData: [String: Any] = [
            "privacy_profile_name": name,
            "privacy_datapoints": datapoints
        ]
        
        trackEvent(title: "create_privacy_profile", data: privacyData)
    }
    
    func setPrivacyProfile(name: String, enabled: Bool) {
        let privacyData: [String: Any] = [
            "privacy_profile_name": name,
            "privacy_enabled": enabled
        ]
        
        trackEvent(title: "set_privacy_profile", data: privacyData)
    }

}
