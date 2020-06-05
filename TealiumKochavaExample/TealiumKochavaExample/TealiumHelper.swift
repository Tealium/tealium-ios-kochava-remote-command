//
//  TealiumHelper.swift
//  TealiumKochavaExample
//
//  Created by Christina S on 6/18/19.
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
    var pushTrackingHelpers = [TealiumRegistration]()

    private init() {
        config.logLevel = .none
        config.shouldUseRemotePublishSettings = false

        tealium = Tealium(config: config,
            enableCompletion: { [weak self] _ in
                guard let self = self else { return }
                guard let remoteCommands = self.tealium?.remoteCommands() else {
                    return
                }
                // MARK: Kochava
                let tealKochavaTracker = TealiumKochavaTracker()
                let kochavaCommand = KochavaRemoteCommand(tealKochavaTracker: tealKochavaTracker).remoteCommand()
                remoteCommands.add(kochavaCommand)
                // Optional Push Message Tracking and Enhanced Deeplinking
                self.deepLinkHelpers.append(tealKochavaTracker)
                self.pushTrackingHelpers.append(tealKochavaTracker)
            })

    }


    public func start() {
        _ = TealiumHelper.shared
    }

    class func trackView(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

    class func trackScreen(_ view: UIViewController, name: String) {
        TealiumHelper.trackView(title: "screen_view", data: ["screen_name": name, "screen_class": "\(view.classForCoder)"])
    }

    class func trackEvent(title: String, data: [String: Any]?) {
        TealiumHelper.shared.tealium?.track(title: title, data: data, completion: nil)
    }

}
