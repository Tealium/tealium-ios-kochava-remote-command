//
//  ContentView.swift
//  TealiumKochavaExample
//
//  Created by Sebastian Krajna on 26/08/2025.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @StateObject private var tealiumHelper = TealiumHelper.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Basic Events Section
                    SectionView(title: "Basic Events", icon: "chart.bar.fill", color: .blue) {
                        TestButton(title: "Track View", icon: "eye.fill") {
                            tealiumHelper.trackView(title: "test_view", data: ["page": "test_page"])
                        }
                        TestButton(title: "Track Event", icon: "bolt.fill") {
                            tealiumHelper.trackEvent(title: "test_event", data: ["category": "testing"])
                        }
                        TestButton(title: "Track Screen", icon: "rectangle.fill") {
                            tealiumHelper.trackScreen("test_screen")
                        }
                    }
                    
                    // E-commerce Events Section
                    SectionView(title: "E-commerce Events", icon: "cart.fill", color: .green) {
                        TestButton(title: "Track Purchase", icon: "creditcard.fill") {
                            tealiumHelper.trackPurchase(
                                orderId: "ORDER-\(Int.random(in: 1000...9999))",
                                total: Double.random(in: 10...500),
                                currency: "USD",
                                products: [["name": "Test Product", "price": 29.99]]
                            )
                        }
                        TestButton(title: "Track Registration", icon: "person.badge.plus.fill") {
                            tealiumHelper.trackRegistration(
                                userId: "USER-\(Int.random(in: 100...999))",
                                method: "email"
                            )
                        }
                        TestButton(title: "Track Login", icon: "person.circle.fill") {
                            tealiumHelper.trackLogin(userId: "USER-123", method: "password")
                        }
                    }
                    
                    // Gaming Events Section
                    SectionView(title: "Gaming Events", icon: "gamecontroller.fill", color: .purple) {
                        TestButton(title: "Track Achievement", icon: "trophy.fill") {
                            tealiumHelper.trackAchievement(
                                achievementId: "ACHIEVEMENT_\(Int.random(in: 1...10))",
                                description: "Test achievement unlocked"
                            )
                        }
                        TestButton(title: "Track Level Complete", icon: "flag.checkered") {
                            tealiumHelper.trackLevelComplete(
                                level: "Level \(Int.random(in: 1...20))",
                                score: Int.random(in: 100...10000),
                                duration: Double.random(in: 30...300)
                            )
                        }
                        TestButton(title: "Track Ad Event", icon: "megaphone.fill") {
                            tealiumHelper.trackAdEvent(
                                eventType: "ad_impression",
                                networkName: "TestNetwork"
                            )
                        }
                    }
                    
                    // Identity & Custom Values Section
                    SectionView(title: "Identity & Custom Values", icon: "person.2.fill", color: .orange) {
                        TestButton(title: "Set Identity Links", icon: "link") {
                            tealiumHelper.setIdentityLinks(identities: [
                                "Email": "test@example.com",
                                "UserID": "12345"
                            ])
                        }
                        TestButton(title: "Link User Identities", icon: "person.3.sequence.fill") {
                            tealiumHelper.linkUserIdentities(
                                userId: "USER-789",
                                email: "user@test.com",
                                username: "testuser"
                            )
                        }
                        TestButton(title: "Set Custom Values", icon: "slider.horizontal.3") {
                            tealiumHelper.setCustomValues([
                                "subscription_tier": "premium",
                                "user_level": Int.random(in: 1...100)
                            ])
                        }
                        TestButton(title: "Set User Tier", icon: "crown.fill") {
                            tealiumHelper.setUserTier("premium")
                        }
                    }
                    
                    // Deeplink Events Section
                    SectionView(title: "Deeplink Events", icon: "link.circle.fill", color: .teal) {
                        TestButton(title: "Standard Deeplink", icon: "link.circle.fill") {
                            tealiumHelper.trackDeeplink(
                                url: "https://example.com/test",
                                type: "standard",
                                activityType: "NSUserActivityTypeBrowsingWeb"
                            )
                        }
                        TestButton(title: "Deferred Deeplink", icon: "clock.arrow.circlepath") {
                            tealiumHelper.trackDeeplink(
                                url: "https://example.com/deferred", 
                                type: "deferred"
                            )
                        }
                        TestButton(title: "URL Scheme", icon: "square.and.arrow.up.fill") {
                            tealiumHelper.trackDeeplink(
                                url: "testapp://open",
                                type: "url_scheme"
                            )
                        }
                        TestButton(title: "Enhanced Deeplink", icon: "wand.and.rays") {
                            tealiumHelper.trackDeeplink(
                                url: "https://example.com/enhanced",
                                type: "enhanced"
                            )
                        }
                    }
                    
                    // Push Notifications Section
                    SectionView(title: "Push Notifications", icon: "bell.circle.fill", color: .pink) {
                        TestButton(title: "Request Permission", icon: "bell.badge.fill") {
                            requestNotificationPermission()
                        }
                        TestButton(title: "Register for Push", icon: "arrow.up.circle.fill") {
                            registerForPushNotifications()
                        }
                        TestButton(title: "Simulate Push Token", icon: "key.fill") {
                            simulatePushToken()
                        }
                        TestButton(title: "Test Local Notification", icon: "bell.fill") {
                            sendTestNotification()
                        }
                    }
                    
                    // Advanced Commands Section
                    SectionView(title: "Advanced Commands", icon: "wrench.and.screwdriver.fill", color: .brown) {
                        TestButton(title: "Set Custom Identifiers", icon: "person.text.rectangle.fill") {
                            tealiumHelper.setCustomIdentifiers([
                                "CRM_ID": "12345",
                                "Email_Hash": "abc123"
                            ])
                        }
                        TestButton(title: "Limit Ad Tracking", icon: "eye.slash.fill") {
                            tealiumHelper.setAppLimitAdTracking(true)
                        }
                        TestButton(title: "Start Tracking", icon: "play.fill") {
                            tealiumHelper.startTracking()
                        }
                        TestButton(title: "Stop Tracking", icon: "stop.fill") {
                            tealiumHelper.stopTracking()
                        }
                    }
                    
                    // Privacy Commands Section
                    SectionView(title: "Privacy Commands", icon: "lock.shield.fill", color: .indigo) {
                        TestButton(title: "Create GDPR Profile", icon: "plus.circle.fill") {
                            tealiumHelper.createPrivacyProfile(
                                name: "GDPR_EU", 
                                datapoints: ["device_name", "idfa"]
                            )
                        }
                        TestButton(title: "Enable Privacy Profile", icon: "checkmark.shield.fill") {
                            tealiumHelper.setPrivacyProfile(name: "GDPR_EU", enabled: true)
                        }
                        TestButton(title: "Disable Privacy Profile", icon: "xmark.shield.fill") {
                            tealiumHelper.setPrivacyProfile(name: "GDPR_EU", enabled: false)
                        }
                    }
                    
                    // System Controls Section
                    SectionView(title: "System Controls", icon: "gear.circle.fill", color: .red) {
                        TestButton(title: "Test Sleep Mode", icon: "moon.fill") {
                            tealiumHelper.testSleepTracker(enabled: true)
                        }
                        TestButton(title: "Test Invalidate", icon: "xmark.circle.fill") {
                            tealiumHelper.testInvalidate()
                        }
                        TestButton(title: "Track App Launch", icon: "play.circle.fill") {
                            tealiumHelper.trackAppLaunchWithoutDeeplink()
                        }
                        TestButton(title: "Open URL Scheme", icon: "link.circle.fill") {
                            openTestURLScheme()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Kochava Test App")
            .navigationBarTitleDisplayMode(.large)

        }
    }
    
    // MARK: - Push Notification Helper Functions
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    tealiumHelper.trackEvent(title: "notification_auth_failed", data: [
                        "error": error.localizedDescription
                    ])
                } else {
                    tealiumHelper.trackEvent(title: "notification_auth_requested", data: [
                        "granted": granted
                    ])
                }
            }
        }
    }
    
    private func registerForPushNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
            tealiumHelper.trackEvent(title: "push_registration_requested", data: [:])
        }
    }
    
    private func simulatePushToken() {
        // Simulate a fake device token for testing
        let fakeToken = "1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef"
        tealiumHelper.trackEvent(title: "push_token_registered", data: [
            "device_token": fakeToken,
            "registration_source": "manual_test"
        ])
    }
    
    private func sendTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test Notification"
        content.body = "This is a test notification from Kochava Test App"
        content.sound = .default
        content.userInfo = ["test": "data", "source": "local"]
        
        let request = UNNotificationRequest(
            identifier: "test-notification-\(Date().timeIntervalSince1970)",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    tealiumHelper.trackEvent(title: "local_notification_failed", data: [
                        "error": error.localizedDescription
                    ])
                } else {
                    tealiumHelper.trackEvent(title: "local_notification_scheduled", data: [
                        "identifier": request.identifier
                    ])
                }
            }
        }
    }
    
    private func openTestURLScheme() {
        // Test opening custom URL scheme
        guard let url = URL(string: "kochavatest://test-deeplink?param=value") else { return }
        
        UIApplication.shared.open(url) { success in
            DispatchQueue.main.async {
                tealiumHelper.trackEvent(title: "url_scheme_open_attempted", data: [
                    "url": url.absoluteString,
                    "success": success
                ])
            }
        }
    }
}


struct SectionView<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title3)
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(spacing: 8) {
                content
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct TestButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(Color(.systemGray5))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}



#Preview {
    ContentView()
}
