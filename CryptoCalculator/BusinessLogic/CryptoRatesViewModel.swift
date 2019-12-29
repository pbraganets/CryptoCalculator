//
//  CryptoRatesViewModel.swift
//  CryptoCalculator
//
//  Created by Pavel B on 01/01/20.
//  Copyright © 2019 Pavel B. All rights reserved.
//

import Foundation
import Combine

enum Base {
    case USD
    case EUR
    case GBP
    
    var isoCode: String {
        switch self {
        case .USD:
            return "USD"
        case .EUR:
            return "EUR"
        case .GBP:
            return "GBP"
        }
    }
    
}


class CryptoRatesViewModel: ObservableObject {
    
    // MARK: - Private properties
    
    private let currentBaseKey = "currentBase"
    private let cryptoRatesFetcher: CryptoRatesFetchable
    private var disposables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    static private let defaultBase: Base = .USD
    
    // MARK: - Public properties
    
    let bases = [Base.USD.isoCode, Base.EUR.isoCode, Base.GBP.isoCode]
    
    @Published private(set) var currentBase: String
    @Published private(set) var rates: [Rate] = []

    // MARK: - Lifecycle
    
    init(cryptoRatesFetcher: CryptoRatesFetchable) {
        self.cryptoRatesFetcher = cryptoRatesFetcher
        currentBase = UserDefaults.standard.string(forKey: currentBaseKey) ?? Self.defaultBase.isoCode
        $currentBase
            .dropFirst(1)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else {
                    return
                }
                UserDefaults.standard.set(self.currentBase, forKey:self.currentBaseKey)
                UserDefaults.standard.synchronize()
                self.fetchCryptoRates(forBase: self.currentBase)
            })
            .store(in: &disposables)
    }
    
    deinit {
        stopUpdate()
    }
    
    // MARK: - Public implementation
    
    func updateBase(_ base: String) {
        currentBase = base
    }
    
    func startUpdate() {
        guard cancellable == nil else {
            return
        }
        
        fetchCryptoRates(forBase: self.currentBase)
        
        // start timer every 5 sec
        cancellable = Timer.publish(every: 5.0, on: RunLoop.main, in: .default)
            .autoconnect()
            .sink (receiveValue: { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.fetchCryptoRates(forBase: self.currentBase)
            })
    }
    
    func stopUpdate() {
        cancellable?.cancel()
        cancellable = nil
    }
    
    // MARK: - Private implementation
    
    private func fetchCryptoRates(forBase base: String) {
        cryptoRatesFetcher.rates(forBase: base)
            .map ({ response in
                response.rates.map(Rate.init)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {
                    return
                }
                switch completion {
                case .failure:
                    self.rates = []
                case .finished:
                    break
                }
                },
                receiveValue: { [weak self] rates in
                    guard let self = self else {
                        return
                    }
                    self.rates = rates
                }
            )
            .store(in: &disposables)
    }
    
}
