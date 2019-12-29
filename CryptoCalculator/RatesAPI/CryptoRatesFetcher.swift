//
//  CryptoRatesFetcher.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation
import Combine

protocol CryptoRatesFetchable {
    func rates(forBase base: String) -> AnyPublisher<CryptoRatesResponse, CryptoRatesError>
}

class CryptoRatesFetcher {
    
    // MARK: - Private implementation
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

// MARK: - CryptoRatesFetchable

extension CryptoRatesFetcher: CryptoRatesFetchable {
    
    func rates(forBase base: String) -> AnyPublisher<CryptoRatesResponse, CryptoRatesError> {
        guard let url = cryptoRatesComponents(withBase: base).url else {
            return Fail(error: CryptoRatesError.network(description: "Couldn't create URL")).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            self.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, CryptoRatesError> {
        let decoder = JSONDecoder()
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
}

// MARK: - cex.io API

private extension CryptoRatesFetcher {
    struct CexAPI {
        static let scheme = "https"
        static let host = "cex.io"
        static let path = "/api"
    }
    
    func cryptoRatesComponents(withBase base: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = CexAPI.scheme
        components.host = CexAPI.host
        components.path = CexAPI.path + "/last_prices" + "/\(base)"
        
        return components
    }
    
}
