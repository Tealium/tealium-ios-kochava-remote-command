//
//  AppDelegate.swift
//  TealiumKochavaExample
//
//  Copyright © 2020 Tealium. All rights reserved.
//

import UIKit
import UserNotifications

// Kochava Push Notification Tracking
// https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-push-notification/
// Enhanced Deeplinking
// https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-using-the-sdk/

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var tealiumHelper: TealiumHelper?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        tealiumHelper = TealiumHelper.shared
        notificationRegistration(application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("🔔 Device Token: \(token)")

        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
        
        // Use Kochava instance directly to register push token
        tealiumHelper?.kochavaInstance?.registerPushToken(deviceTokenString)
        
        // Track push token registration event
        TealiumHelper.trackEvent(title: "push_token_registered", data: [
            "device_token": token,
            "registration_source": "app_launch"
        ])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
        
        // Track push registration failure
        TealiumHelper.trackEvent(title: "push_registration_failed", data: [
            "error_description": error.localizedDescription
        ])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("📩 Received push notification: \(userInfo)")
        
        // Use Kochava instance directly to log push notification receipt/open
        tealiumHelper?.kochavaInstance?.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
        // Track push notification received event
        TealiumHelper.trackEvent(title: "push_received", data: [
            "notification_payload": userInfo,
            "app_state": application.applicationState == .active ? "active" : "background"
        ])
        
        completionHandler(.newData)
    }
    
    

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("🔗 Deep link received: \(userActivity.webpageURL?.absoluteString ?? "No URL")")
        
        // Track deep link event
        if let url = userActivity.webpageURL {
            TealiumHelper.trackEvent(title: "deeplink_received", data: [
                "deeplink_url": url.absoluteString,
                "activity_type": userActivity.activityType,
                "source_application": userActivity.userInfo?["source_application"] as? String ?? "unknown"
            ])
        }
        
        // Use remote command to handle deep link
        var handled = false
        tealiumHelper?.deepLinkHelpers.forEach {
            if $0.application(application, continue: userActivity, restorationHandler: restorationHandler) {
                handled = true
            }
        }
        
        return handled
    }
    
    // MARK: - URL Handling for custom schemes
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("🔗 URL scheme received: \(url.absoluteString)")
        
        // Track URL scheme event
        TealiumHelper.trackEvent(title: "url_scheme_opened", data: [
            "url": url.absoluteString,
            "scheme": url.scheme ?? "unknown",
            "source_application": options[.sourceApplication] as? String ?? "unknown"
        ])
        
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("📱 User interacted with notification: \(response.actionIdentifier)")
        
        // Use Kochava instance directly to log push notification receipt/open
        tealiumHelper?.kochavaInstance?.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
        
        // Track notification interaction
        TealiumHelper.trackEvent(title: "push_opened", data: [
            "action_identifier": response.actionIdentifier,
            "notification_title": response.notification.request.content.title,
            "notification_body": response.notification.request.content.body,
            "user_info": response.notification.request.content.userInfo
        ])
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("📱 Will present notification while app is active")
        
        // Track notification presentation
        TealiumHelper.trackEvent(title: "push_displayed", data: [
            "notification_title": notification.request.content.title,
            "notification_body": notification.request.content.body,
            "app_state": "active"
        ])
        
        // Show notification even when app is active
        completionHandler([.alert, .badge, .sound])
    }
    
    func notificationRegistration(_ application: UIApplication) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("❌ Notification authorization error: \(error.localizedDescription)")
                    
                    // Track authorization failure
                    TealiumHelper.trackEvent(title: "notification_auth_failed", data: [
                        "error": error.localizedDescription
                    ])
                    return
                }
                
                print("📱 Notification authorization granted: \(granted)")
                
                // Track authorization result
                TealiumHelper.trackEvent(title: "notification_auth_requested", data: [
                    "granted": granted
                ])
                
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
            
            // Always try to register for remote notifications
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        } else {
            // Fallback for iOS 9 and earlier
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
}
