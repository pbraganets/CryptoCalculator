//
//  DiffAware+Hashable.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation
import DeepDiff

extension DiffAware where Self: Hashable {
    public var diffId: Int {
        return hashValue
    }

    public static func compareContent(_ a: Self, _ b: Self) -> Bool {
        return a == b
    }
    
}
