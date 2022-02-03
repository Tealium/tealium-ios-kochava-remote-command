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
    var pushMessagingHelpers = [TealiumRegistration]()
    
    private init() {
        config.shouldUseRemotePublishSettings = false
        config.batchingEnabled = false
        config.remoteAPIEnabled = true
        config.logLevel = .info
        config.collectors = [Collectors.Lifecycle]
        config.dispatchers = [Dispatchers.RemoteCommands]
                
        tealium = Tealium(config: config) { [weak self] _ in
            guard let self = self,
                  let remoteCommands = self.tealium?.remoteCommands else {
                return
            }
            // MARK: Kochava JSON Remote Command
            let kochavaInstance = KochavaInstance()
            let kochavaRemoteCommand = KochavaRemoteCommand(kochavaInstance: kochavaInstance, type: .remote(url: "https://tags.tiqcdn.com/dle/tealiummobile/demo/kochava.json"))
            remoteCommands.add(kochavaRemoteCommand)
            // Optional Push Message Tracking and Enhanced Deeplinking
            self.deepLinkHelpers.append(kochavaInstance)
            self.pushMessagingHelpers.append(kochavaInstance)
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

}
