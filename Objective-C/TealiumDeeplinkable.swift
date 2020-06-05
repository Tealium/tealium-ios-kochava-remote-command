//
//  TealiumDeepLinkable.swift
//  TealiumKochava
//
//  Created by Christina S on 2/24/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import UIKit

public protocol TealiumApplication { }
extension UIApplication: TealiumApplication { }

protocol TealiumDeepLinkable {
    func application(_ application: TealiumApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
}
