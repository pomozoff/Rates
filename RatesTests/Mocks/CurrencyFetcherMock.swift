//
//  CurrencyFetcherMock.swift
//  RatesTests
//
//  Created by Anton Pomozov on 30/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import UIKit
@testable import Rates

final class CurrencyFetcherMock {

    var assetName: String
    var numberOfLoadedRates: Int = 0

    init(assetName: String) {
        self.assetName = assetName
    }

}

// MARK: - CurrencyFetcher

extension CurrencyFetcherMock: CurrencyFetcher {

    func fetchCurrencyList(url: URL, completion: @escaping (Result<CurrencyRates>) -> Void) {
        guard let asset = NSDataAsset(name: assetName, bundle: Bundle(for: CurrencyFetcherMock.self)) else {
            return completion(.failure(NetworkError.emptyData("Failed to load asset: \(assetName)").error))
        }
        guard let rates = try? JSONDecoder().decode(CurrencyRates.self, from: asset.data) else {
            completion(.failure(NetworkError.decoding("Failed to parse data: \(asset.data)").error))
            return
        }

        numberOfLoadedRates = rates.rates.count + 1

        completion(.success(rates))
    }

}
