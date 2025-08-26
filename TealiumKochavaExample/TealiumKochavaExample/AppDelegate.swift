import UIKit
import UserNotifications

// Kochava Push Notification Tracking
// https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-push-notification/
// Enhanced Deeplinking
// https://support.kochava.com/sdk-integration/ios-sdk-integration/ios-using-the-sdk/

class AppDelegate: NSObject, UIApplicationDelegate {

    var tealiumHelper: TealiumHelper?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        tealiumHelper = TealiumHelper.shared
        notificationRegistration(application)
        
        // Example: Track app launch without deeplink (for analytics)
        tealiumHelper?.trackAppLaunchWithoutDeeplink(launchType: "normal_launch")
        
        // For Enhanced Deferred Deeplinking, implement native Kochava SDK here if needed:
        // Example (check for deferred deeplink when no direct deeplink on launch):
        // let userActivityDictionary = launchOptions?[UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any]
        // if userActivityDictionary == nil {
        //     Deeplink.process(url: nil, timeoutTimeInterval: 15.0) { deeplink in
        //         guard let destination = deeplink.destinationString, destination.count > 0 else { 
        //             // No deferred deeplink found
        //             return
        //         }
        //         
        //         // Track deferred deeplink analytics
        //         tealiumHelper?.trackDeeplinkDeferred(url: destination, timeout: 15.0)
        //         
        //         // Route user to destination
        //         DispatchQueue.main.async {
        //             self.routeUser(to: destination)
        //         }
        //     }
        // }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print("🔔 Device Token: \(token)")

        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
        
        // Use Kochava instance directly to register push token
        tealiumHelper?.kochavaInstance?.registerPushToken(deviceTokenString)
        
        // Track push token registration event
        tealiumHelper?.trackEvent(title: "push_token_registered", data: [
            "device_token": token,
            "registration_source": "app_launch"
        ])
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
        
        // Track push registration failure
        tealiumHelper?.trackEvent(title: "push_registration_failed", data: [
            "error_description": error.localizedDescription
        ])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("📩 Received push notification: \(userInfo)")
        
        // Use Kochava instance directly to log push notification receipt/open
        tealiumHelper?.kochavaInstance?.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
        // Track push notification received event
        tealiumHelper?.trackEvent(title: "push_received", data: [
            "notification_payload": userInfo,
            "app_state": application.applicationState == .active ? "active" : "background"
        ])
        
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        print("🔗 Deep link received: \(userActivity.webpageURL?.absoluteString ?? "No URL")")
        
        // Track deeplink analytics event via Remote Command helper
        if let url = userActivity.webpageURL {
            tealiumHelper?.trackDeeplink(
                url: url.absoluteString,
                type: "standard",
                activityType: userActivity.activityType,
                sourceApp: userActivity.userInfo?["source_application"] as? String
            )
        }
        
        // For Enhanced Deeplinking (routing/navigation), implement native Kochava SDK here if needed:
        // Example:
        // if let url = userActivity.webpageURL {
        //     Deeplink.process(url: url, timeoutTimeInterval: 10.0) { deeplink in
        //         let originalUrl = url.absoluteString
        //         let destination = deeplink.destinationString
        //         let success = destination != nil && destination!.count > 0
        //         
        //         // Track deeplink processing analytics
        //         tealiumHelper?.trackDeeplinkProcessed(
        //             originalUrl: originalUrl,
        //             finalDestination: destination,
        //             success: success,
        //             timeout: 10.0
        //         )
        //         
        //         // Route user to destination if successful
        //         if success {
        //             DispatchQueue.main.async {
        //                 self.routeUser(to: destination!)
        //             }
        //         }
        //     }
        // }
        
        return true
    }
    
    // MARK: - URL Handling for custom schemes
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("🔗 URL scheme received: \(url.absoluteString)")
        
        // Track URL scheme analytics via Remote Command helper
        tealiumHelper?.trackUrlSchemeOpened(
            url: url.absoluteString,
            scheme: url.scheme ?? "unknown",
            sourceApp: options[.sourceApplication] as? String
        )
        
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("📱 User interacted with notification: \(response.actionIdentifier)")
        
        // Use Kochava instance directly to log push notification receipt/open
        tealiumHelper?.kochavaInstance?.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
        
        // Track notification interaction
        tealiumHelper?.trackEvent(title: "push_opened", data: [
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
        tealiumHelper?.trackEvent(title: "push_displayed", data: [
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
                    self.tealiumHelper?.trackEvent(title: "notification_auth_failed", data: [
                        "error": error.localizedDescription
                    ])
                    return
                }
                
                print("📱 Notification authorization granted: \(granted)")
                
                // Track authorization result
                self.tealiumHelper?.trackEvent(title: "notification_auth_requested", data: [
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
