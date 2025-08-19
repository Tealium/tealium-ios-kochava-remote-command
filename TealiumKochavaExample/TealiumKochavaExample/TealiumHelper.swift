//
//  TealiumHelper.swift
//  TealiumKochavaExample
//
//  Copyright © 2019 Tealium. All rights reserved.
//

import Foundation
import TealiumSwift
import TealiumKochava

enum TealiumConfiguration {
    static let account = "tealiummobile"
    static let profile = "kochava"
    static let environment = "dev"
}

class TealiumHelper {

    static let shared = TealiumHelper()

    let config = TealiumConfig(account: TealiumConfiguration.account,
        profile: TealiumConfiguration.profile,
        environment: TealiumConfiguration.environment)

    var tealium: Tealium?
    var deepLinkHelpers = [TealiumDeepLinkable]()
    var kochavaInstance: KochavaInstance?
    
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
            
            let kochavaInstance = KochavaInstance()
            self.kochavaInstance = kochavaInstance
            
            // Używamy lokalnego pliku JSON z backupem zdalnym
            let kochavaRemoteCommand = KochavaRemoteCommand(
                kochavaInstance: kochavaInstance,
                type: .local(file: "kochava")
            )
            
            // Set callback for when Kochava is ready
            kochavaRemoteCommand.onReady {
                print("🚀 Kochava SDK is ready!")
            }
            
            remoteCommands.add(kochavaRemoteCommand)
            
            // Optional Enhanced Deeplinking
            self.deepLinkHelpers.append(kochavaInstance)
        }
    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        let tealiumView = TealiumView(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumView)
    }

    class func trackScreen(_ view: UIViewController, name: String) {
        TealiumHelper.trackView(title: "screen_view", data: ["screen_name": name, "screen_class": "\(view.classForCoder)"])
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        let tealiumEvent = TealiumEvent(title, dataLayer: data)
        TealiumHelper.shared.tealium?.track(tealiumEvent)
    
    }
    
    // MARK: - Specialized tracking methods for better testing
    
    /// Track purchase events with enhanced data
    class func trackPurchase(orderId: String, total: Double, currency: String, products: [[String: Any]]?) {
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
    
    /// Track achievement events
    class func trackAchievement(achievementId: String, description: String? = nil) {
        var achievementData: [String: Any] = [
            "achievement_id": achievementId
        ]
        
        if let description = description {
            achievementData["description"] = description
        }
        
        trackEvent(title: "unlock_achievement", data: achievementData)
    }
    
    /// Track level completion with score and duration
    class func trackLevelComplete(level: String, score: Int? = nil, duration: TimeInterval? = nil) {
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
    
    /// Track registration with method
    class func trackRegistration(userId: String, method: String, userData: [String: Any]? = nil) {
        var registrationData: [String: Any] = [
            "customer_id": userId,
            "signup_method": method
        ]
        
        if let userData = userData {
            registrationData.merge(userData) { (_, new) in new }
        }
        
        trackEvent(title: "user_register", data: registrationData)
    }
    
    /// Track login events
    class func trackLogin(userId: String, method: String) {
        let loginData: [String: Any] = [
            "customer_id": userId,
            "signup_method": method
        ]
        
        trackEvent(title: "user_login", data: loginData)
    }
    
    /// Track ad events
    class func trackAdEvent(eventType: String, networkName: String, campaignId: String? = nil) {
        var adData: [String: Any] = [
            "ad_network_name": networkName
        ]
        
        if let campaignId = campaignId {
            adData["campaign_id"] = campaignId
        }
        
        trackEvent(title: eventType, data: adData)
    }
    
    /// Test sleep tracker functionality
    class func testSleepTracker(enabled: Bool) {
        let sleepData: [String: Any] = [
            "sleep_tracker": enabled
        ]
        
        trackEvent(title: "sleeptracker", data: sleepData)
    }
    
    /// Test invalidate functionality
    class func testInvalidate() {
        trackEvent(title: "invalidate", data: nil)
    }

}
