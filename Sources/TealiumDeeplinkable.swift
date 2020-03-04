//
//  TealiumDeeplinkable.swift
//  json-rc-test
//
//  Created by Christina S on 2/24/20.
//  Copyright © 2020 Schelly. All rights reserved.
//

import UIKit

public protocol TealiumApplication { }
extension UIApplication: TealiumApplication { }

public protocol TealiumDeepLinkable {
    func application(_ application: TealiumApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
}
