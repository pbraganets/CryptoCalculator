//
//  CryptoRatesResponse.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation

struct CryptoRatesResponse: Codable {
    let rates: [Item]
    
    struct Item: Codable {
        let symbol1: String
        let symbol2: String
        let lprice: String
        
        enum CodingKeys: String, CodingKey {
            case symbol1
            case symbol2
            case lprice
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case rates = "data"
    }
    
}
