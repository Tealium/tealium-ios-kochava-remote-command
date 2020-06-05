//
//  MockKochavaEvent.swift
//  TealiumKochava
//
//  Created by Christina S on 6/3/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation
@testable import TealiumKochava

@objc
class MockKochavaEvent: NSObject, KochavaEventProtocol {
    
    @objc let firstName: String
    @objc let lastName: String
    @objc let companyName: String
    @objc let address: String
    @objc let city: String
    @objc let county: String
    @objc let state: String
    @objc let zip: String
    @objc let phone1: String
    @objc let phone2: String
    @objc let email: String
    @objc let web: String
    
    public override init() {
        self.firstName = ""
        self.lastName = ""
        self.companyName = ""
        self.address = ""
        self.city = ""
        self.county = ""
        self.state = ""
        self.zip = ""
        self.phone1 = ""
        self.phone2 = ""
        self.email = ""
        self.web = ""
    }
}
