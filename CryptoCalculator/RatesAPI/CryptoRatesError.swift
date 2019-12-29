//
//  CryptoRatesError.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation

enum CryptoRatesError: Error {
  case parsing(description: String)
  case network(description: String)
}
