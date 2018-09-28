//
//  CurrencyDataSource.swift
//  CurrencyConverter
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation

protocol CurrencyDataSource: class {

    var count: Int { get }
    subscript(index: Int) -> CurrencyView { get }

}

protocol CurrencyList: class {

    var amount: Decimal { get set }
    var rates: CurrencyRates! { get set }

    func move(from indexFrom: Int, to indexTo: Int)

}

final class CurrencyDataSourceImpl {

    typealias CurrencyList = [Currency]

    // MARK: - CurrencyList

    var amount: Decimal = 0.0 {
        didSet {
            currencyList = updateAmount(of: currencyList)
        }
    }
    var rates: CurrencyRates! {
        didSet {
            if baseCurrency == nil {
                baseCurrency = Currency(id: rates.base,
                                        name: currencyData[rates.base]?.1 ?? "",
                                        rate: 1.0,
                                        amount: amount,
                                        country: currencyData[rates.base]?.0 ?? "")
            }

            // FIXME: Later. Not too many items to optimize it right now.
            var sortedList = rates.rates
                .map({ Currency(id: $0.key,
                                name: currencyData[$0.key]?.1 ?? "",
                                rate: $0.value,
                                amount: amount(of: $0.value),
                                country: currencyData[$0.key]?.0 ?? "") })
                .sorted(by: { $0.id < $1.id })

            sortedList.insert(baseCurrency, at: 0)
            currencyList = sortedList.compactMap { currencyList.contains($0) ? nil : $0 }
        }
    }

    // MARK: - Life cycle

    init(currencyData: [String : (String, String)]) {
        self.currencyData = currencyData
    }

    // MARK: - Private

    private let currencyData: [String : (String, String)]
    private var currencyList: CurrencyList = []
    private var baseCurrency: Currency!

}

// MARK: - CurrencyDataSource

extension CurrencyDataSourceImpl: CurrencyDataSource {

    var count: Int {
        return currencyList.count
    }

    subscript(index: Int) -> CurrencyView {
        return currencyList[index]
    }
    
}

// MARK: - CurrencyList

extension CurrencyDataSourceImpl: CurrencyList {

    func move(from indexFrom: Int, to indexTo: Int) {
        let currency = currencyList[indexFrom]
        currencyList.remove(at: indexFrom)
        currencyList.insert(currency, at: 0)
    }

}

// MARK: - Private

private extension CurrencyDataSourceImpl {

    private func amount(of rate: Decimal) -> Decimal {
        return amount * rate / baseCurrency.rate
    }

    private func updateAmount(of currencyList: CurrencyList) -> CurrencyList {
        return currencyList.map { Currency(id: $0.id,
                                           name: $0.name,
                                           rate: $0.rate,
                                           amount: amount(of: $0.rate),
                                           country: $0.country) }
    }

}
