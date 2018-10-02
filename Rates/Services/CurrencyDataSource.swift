//
//  CurrencyDataSource.swift
//  Rates
//
//  Created by Anton Pomozov on 24/09/2018.
//  Copyright © 2018 Anton Pomozov. All rights reserved.
//

import Foundation
import Changeset

protocol CurrencyDataSource: class {

    var count: Int { get }
    subscript(index: Int) -> CurrencyView { get }

}

protocol CurrencyList: class {

    var baseCurrency: Currency! { get }

    func setAsNewBaseCurrency(at row: Int)
    func updateCurrencyList(with rates: CurrencyRates) -> Changeset<[Currency]>
    func updateCurrencyList(with amount: Decimal) -> Changeset<[Currency]>

}

final class CurrencyDataSourceImpl {

    // MARK: - CurrencyList

    var baseCurrency: Currency!

    // MARK: - Life cycle

    init(currencyData: [String : (String, String)]) {
        self.currencyData = currencyData
    }

    // MARK: - Private

    private let currencyComparator: (Currency, Currency) -> Bool = {
        $0.id == $1.id && $0.rate == $1.rate
    }

    private let currencyData: [String : (String, String)]
    private var currencyList: [Currency] = []

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

    func setAsNewBaseCurrency(at row: Int) {
        baseCurrency = currencyList[row]
        move(from: row, to: 0)
    }

    func updateCurrencyList(with rates: CurrencyRates) -> Changeset<[Currency]> {
        if baseCurrency == nil {
            baseCurrency = Currency(id: rates.base,
                                    name: currencyData[rates.base]?.1 ?? "",
                                    rate: 1.0,
                                    amount: 0.0,
                                    country: currencyData[rates.base]?.0 ?? "")
        }

        // FIXME: Later. Not too many items to optimize it right now.
        var sortedList = rates.rates
            .map({ Currency(id: $0.key,
                            name: currencyData[$0.key]?.1 ?? "",
                            rate: $0.value,
                            amount: $0.value * baseCurrency.amount,
                            country: currencyData[$0.key]?.0 ?? "") })
            .sorted(by: { $0.id < $1.id })

        sortedList.insert(baseCurrency, at: 0)

        return updateCurrencyList(with: sortedList)
    }

    func updateCurrencyList(with amount: Decimal) -> Changeset<[Currency]> {
        baseCurrency.amount = amount
        let newCurrencyList = currencyList.compactMap { (currency) -> Currency? in
            guard currency.id != baseCurrency.id else { return currency }
            return Currency(id: currency.id,
                            name: currency.name,
                            rate: currency.rate,
                            amount: currency.rate * baseCurrency.amount,
                            country: currency.country)
        }
        return updateCurrencyList(with: newCurrencyList)
    }

}

// MARK: - Private

private extension CurrencyDataSourceImpl {

    private func move(from indexFrom: Int, to indexTo: Int) {
        let currency = currencyList[indexFrom]
        currencyList.remove(at: indexFrom)
        currencyList.insert(currency, at: 0)
    }

    private func updateCurrencyList(with newCurrencyList: [Currency]) -> Changeset<[Currency]> {
        let changeset = Changeset(source: currencyList, target: newCurrencyList, comparator: currencyComparator)
        currencyList = newCurrencyList

        return changeset
    }

}
