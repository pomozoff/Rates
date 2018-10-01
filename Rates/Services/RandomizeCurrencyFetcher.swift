//
//  RandomizeCurrencyFetcher.swift
//  Rates
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

final class RandomizeCurrencyFetcher {

    // MARK: - Life cycle

    init(currencyFetcher: CurrencyFetcher) {
        self.currencyFetcher = currencyFetcher
    }

    // MARK: - Private

    private let currencyFetcher: CurrencyFetcher

}

// MARK: - CurrencyFetcher

extension RandomizeCurrencyFetcher: CurrencyFetcher {

    func fetchCurrencyList(url: URL, completion: @escaping (Result<CurrencyRates>) -> Void) {
        currencyFetcher.fetchCurrencyList(url: url) { result in
            switch result {
            case .failure(_):
                completion(result)
            case .success(let rateList):
                let changedRateList: [String : Decimal] = rateList.rates.reduce(into: [:]) { result, currencyRate in
                    var value = currencyRate.value

                    defer {
                        result[currencyRate.key] = value
                    }

                    guard arc4random_uniform(10) < 2 else { return }

                    let multiplier = (Decimal(arc4random_uniform(10)) / 100) + 0.95
                    value *= multiplier
                }
                let modifiedResult = CurrencyRates(base: rateList.base, date: rateList.date, rates: changedRateList)
                completion(.success(modifiedResult))
            }
        }
    }

}
