//
//  AppDelegate.swift
//  TealiumKochavaExample
//
//  Created by Christina S on 2/24/20.
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
        print(token)

        let deviceTokenString = String(format: "%@", deviceToken as CVarArg)
        
        // Use remote command to register push token
        tealiumHelper?.pushTrackingHelpers.forEach {
            $0.registerPushToken(deviceTokenString)
        }
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
        
        // Use remote command to log push notification receipt/open
        tealiumHelper?.pushTrackingHelpers.forEach {
            $0.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // Use remote command to handle deep link
        tealiumHelper?.deepLinkHelpers.forEach {
            _ = $0.application(application, continue: userActivity, restorationHandler: restorationHandler)
        }
        
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // Use remote command to log push notification receipt/open
        tealiumHelper?.pushTrackingHelpers.forEach {
            $0.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
        }
        
    }
    
    func notificationRegistration(_ application: UIApplication) {
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                guard error == nil else {
                    return
                }
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
            }
            application.registerForRemoteNotifications()
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
}
