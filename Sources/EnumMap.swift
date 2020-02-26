//
//  EnumMap.swift
//  TealiumKochava
//
//  Created by Christina S on 2/21/20.
//  Copyright © 2020 Tealium. All rights reserved.
//

import Foundation

/// Thanks to John Sundell https://www.swiftbysundell.com/articles/enum-iterations-in-swift-42/
struct EnumMap<T: CaseIterable & Hashable, U> {
    private let values: [T: U]
    
    init(resolver: (T) -> U) {
        var values = [T: U]()
        
        for key in T.allCases {
            values[key] = resolver(key)
        }
        
        self.values = values
    }
    
    subscript(key: T) -> U {
        return values[key]!
    }
}
