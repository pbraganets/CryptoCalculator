//
//  Rate.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation
import DeepDiff

struct Rate: Codable, Hashable {
    
    let base: String
    let crypto: String
    let value: Double
    
    init(item: CryptoRatesResponse.Item) {
        base = item.symbol2
        crypto = item.symbol1
        value = Double(item.lprice) ?? 0.0
    }
    
    init(base: String, crypto: String, value: Double) {
        self.base = base
        self.crypto = crypto
        self.value = value
    }
    
    enum CodingKeys: String, CodingKey {
        case base
        case crypto
        case value
    }
    
}

extension Rate: DiffAware {}
