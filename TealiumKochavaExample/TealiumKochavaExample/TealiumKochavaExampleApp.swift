//
//  TealiumKochavaExampleApp.swift
//  TealiumKochavaExample
//
//  Created by Sebastian Krajna on 26/08/2025.
//

import SwiftUI

@main
struct TealiumKochavaExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private var tealiumHelper = TealiumHelper.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tealiumHelper)
                .onAppear {
                    // Initialize Tealium when app appears
                    tealiumHelper.start()
                }
        }
    }
}
